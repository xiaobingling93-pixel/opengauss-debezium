-- =============================================
-- 【第一步：安全清理旧对象】
-- =============================================
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE user_info CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE order_info CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE normal_seq';
    EXECUTE IMMEDIATE 'DROP SEQUENCE cycle_seq';
    EXECUTE IMMEDIATE 'DROP SEQUENCE maxvalue_seq';
    EXECUTE IMMEDIATE 'DROP SEQUENCE minvalue_neg_seq';
    EXECUTE IMMEDIATE 'DROP SEQUENCE increment_neg_seq';
    EXECUTE IMMEDIATE 'DROP SEQUENCE nocache_seq';
    EXECUTE IMMEDIATE 'DROP SEQUENCE order_seq';
    EXECUTE IMMEDIATE 'DROP SEQUENCE start_from_1000_seq';
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_user_id';
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_order_id';
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_common_shared';
EXCEPTION WHEN OTHERS THEN NULL; END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_user_auto_id';
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_order_auto_id';
EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- =============================================
-- 【第二部分：全场景序列创建（已修复所有报错）】
-- =============================================

-- 场景1：标准默认序列
CREATE SEQUENCE normal_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCYCLE
CACHE 20;

-- 场景2：循环序列（修复 ORA-04013：必须 NOCACHE）
CREATE SEQUENCE cycle_seq
START WITH 1
INCREMENT BY 1
MAXVALUE 5
CYCLE
NOCACHE;  -- 关键修复

-- 场景3：带最大值、不循环
CREATE SEQUENCE maxvalue_seq
START WITH 1
INCREMENT BY 5
MAXVALUE 50
NOCYCLE;

-- 场景4：负数最小值序列
CREATE SEQUENCE minvalue_neg_seq
MINVALUE -100
START WITH -10
INCREMENT BY 1
MAXVALUE 100
NOCYCLE;

-- 场景5：递减序列（修复 ORA-04004：必须加 MAXVALUE）
CREATE SEQUENCE increment_neg_seq
START WITH 100
INCREMENT BY -10
MINVALUE 0
MAXVALUE 100  -- 关键修复
NOCYCLE;

-- 场景6：无缓存序列
CREATE SEQUENCE nocache_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 场景7：RAC 强制排序序列
CREATE SEQUENCE order_seq
START WITH 1
INCREMENT BY 1
CACHE 10
ORDER;

-- 场景8：大起始值序列
CREATE SEQUENCE start_from_1000_seq
START WITH 1000
INCREMENT BY 1
MAXVALUE 999999999
NOCYCLE;

-- =============================================
-- 【第三部分：序列 + 表绑定实战】
-- =============================================

-- 1. 用户表 + 专用序列
CREATE TABLE user_info (
    user_id    NUMBER(10) PRIMARY KEY,
    username   VARCHAR2(50),
    create_time DATE DEFAULT SYSDATE
);

CREATE SEQUENCE seq_user_id
START WITH 1001
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER trg_user_auto_id
BEFORE INSERT ON user_info
FOR EACH ROW
BEGIN
    IF :NEW.user_id IS NULL THEN
        SELECT seq_user_id.NEXTVAL INTO :NEW.user_id FROM DUAL;
    END IF;
END;
/

-- 2. 订单表 + 专用序列
CREATE TABLE order_info (
    order_id    NUMBER(10) PRIMARY KEY,
    user_id     NUMBER(10),
    order_name  VARCHAR2(100),
    create_time DATE DEFAULT SYSDATE
);

CREATE SEQUENCE seq_order_id
START WITH 100001
INCREMENT BY 1
CACHE 10;

CREATE OR REPLACE TRIGGER trg_order_auto_id
BEFORE INSERT ON order_info
FOR EACH ROW
BEGIN
    IF :NEW.order_id IS NULL THEN
        SELECT seq_order_id.NEXTVAL INTO :NEW.order_id FROM DUAL;
    END IF;
END;
/

-- 3. 多表共享全局序列
CREATE SEQUENCE seq_common_shared
START WITH 1000000
INCREMENT BY 1
CACHE 20;

-- 测试表1：商品表
CREATE TABLE goods_info (
    goods_id    NUMBER(10) PRIMARY KEY,  -- 共享全局ID
    goods_name  VARCHAR2(50)
);

-- 测试表2：支付记录表
CREATE TABLE pay_log (
    pay_id      NUMBER(10) PRIMARY KEY,  -- 共享全局ID
    user_id     NUMBER(10),
    pay_money   NUMBER(10,2)
);

-- 商品表使用共享序列
INSERT INTO goods_info (goods_id, goods_name) VALUES (seq_common_shared.NEXTVAL, 'iPhone 16');

-- 支付表使用同一个共享序列
INSERT INTO pay_log (pay_id, user_id, pay_money) VALUES (seq_common_shared.NEXTVAL, 1001, 5999);

-- 再次插入商品表
INSERT INTO goods_info (goods_id, goods_name) VALUES (seq_common_shared.NEXTVAL, 'iPad Pro');

-- 再次插入支付表
INSERT INTO pay_log (pay_id, user_id, pay_money) VALUES (seq_common_shared.NEXTVAL, 1002, 3299);
COMMIT;
/
