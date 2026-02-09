CREATE DATABASE IF NOT EXISTS tech_barn;
USE tech_barn;

CREATE TABLE Admin (
    admin_id    INT AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(20) NOT NULL,
    last_name   VARCHAR(20) NOT NULL,
    username    VARCHAR(50) NOT NULL,
    salary      INT,
    password    VARCHAR(20) NOT NULL,
    email       VARCHAR(50) NOT NULL,
    phone_no    CHAR(10)
);

CREATE TABLE Cust_Rep (
    rep_id      INT AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(20) NOT NULL,
    last_name   VARCHAR(20) NOT NULL,
    username    VARCHAR(50) NOT NULL,
    salary      INT,
    password    VARCHAR(20) NOT NULL,
    email       VARCHAR(50) NOT NULL,
    phone_no    CHAR(10),
    region      VARCHAR(50),
    admin_id    INT NOT NULL,
    CONSTRAINT fk_custrep_admin
        FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)
);

CREATE TABLE Address (
    address_id  INT AUTO_INCREMENT PRIMARY KEY,
    street_name VARCHAR(100) NOT NULL,
    apt_no      VARCHAR(10),
    city        VARCHAR(20) NOT NULL,
    state       VARCHAR(20) NOT NULL,
    zip         VARCHAR(10) NOT NULL
);

CREATE TABLE `User` (
    user_id     INT AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(20) NOT NULL,
    last_name   VARCHAR(20) NOT NULL,
    created_at  DATE,
    email       VARCHAR(50) NOT NULL,
    phone_no    CHAR(10),
    username    VARCHAR(50) NOT NULL,
    password    VARCHAR(20) NOT NULL,
    dob         DATE,
    address_id  INT,
    isBuyer     TINYINT(1) NOT NULL DEFAULT 0,
    isSeller    TINYINT(1) NOT NULL DEFAULT 0,
    rating      FLOAT,
    CONSTRAINT fk_user_address
        FOREIGN KEY (address_id) REFERENCES Address(address_id)
);

CREATE TABLE Card (
    card_id     INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    card_name   VARCHAR(50) NOT NULL,
    card_no     CHAR(16) NOT NULL,
    exp_date    DATE NOT NULL,
    cvc         CHAR(3) NOT NULL,
    bill_add_id INT NOT NULL,
    CONSTRAINT fk_card_user
        FOREIGN KEY (user_id) REFERENCES `User`(user_id),
    CONSTRAINT fk_card_address
        FOREIGN KEY (bill_add_id) REFERENCES Address(address_id)
);

CREATE TABLE Account (
    account_id      INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL,
    account_name    VARCHAR(50),
    routing_number  CHAR(9) NOT NULL,
    account_number  VARCHAR(20) NOT NULL,
    CONSTRAINT fk_account_user
        FOREIGN KEY (user_id) REFERENCES `User`(user_id)
);

CREATE TABLE Item (
    item_id     INT AUTO_INCREMENT PRIMARY KEY,
    brand       VARCHAR(20) NOT NULL,
    `condition` VARCHAR(20) NOT NULL,
    title       VARCHAR(20) NOT NULL,
    category_id TINYINT NOT NULL,
    color       VARCHAR(20),
    in_stock    TINYINT(1) NOT NULL DEFAULT 1,
    image_path  VARCHAR(255),
    `description` VARCHAR(300)
);

CREATE TABLE Phone (
    item_id           INT PRIMARY KEY,
    os                VARCHAR(10) NOT NULL,
    storage_gb        INT NOT NULL,
    ram_gb            INT NOT NULL,
    phone_screen_size       FLOAT NOT NULL,
    rear_camera_mp    INT NOT NULL,
    front_camera_mp   INT NOT NULL,
    isUnlocked        TINYINT(1) NOT NULL DEFAULT 0,
    phone_battery_life      INT NOT NULL,
    is5G              TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT fk_phone_item
        FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

CREATE TABLE TV (
    item_id      INT PRIMARY KEY,
    resolution   VARCHAR(20) NOT NULL,
    isHdr        TINYINT(1) NOT NULL DEFAULT 0,
    refresh_rate INT NOT NULL,
    isSmartTv    TINYINT(1) NOT NULL DEFAULT 0,
    tv_screen_size  INT NOT NULL,
    panel_type   VARCHAR(20) NOT NULL,
    CONSTRAINT fk_tv_item
        FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

CREATE TABLE Headphones (
    item_id              INT PRIMARY KEY,
    isWireless           TINYINT(1) NOT NULL DEFAULT 0,
    hasMicrophone        TINYINT(1) NOT NULL DEFAULT 0,
    hasNoiseCancellation TINYINT(1) NOT NULL DEFAULT 0,
    cable_type           VARCHAR(10) NOT NULL,
    phone_battery_life      INT NOT NULL,
    CONSTRAINT fk_headphones_item
        FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

CREATE TABLE Auction (
    auction_id      INT AUTO_INCREMENT PRIMARY KEY,
    start_time      DATETIME NOT NULL,
    end_time        DATETIME NOT NULL,
    increment       DECIMAL(10,2) NOT NULL,
    status          VARCHAR(20) NOT NULL,
    minimum_price   DECIMAL(10,2) NOT NULL,
    starting_price  DECIMAL(10,2) NOT NULL,
    seller_id       INT NOT NULL,
    item_id         INT NOT NULL,
    CONSTRAINT fk_auction_seller
        FOREIGN KEY (seller_id) REFERENCES `User`(user_id),
    CONSTRAINT fk_auction_item
        FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

CREATE TABLE `Transaction` (
    trans_id    INT AUTO_INCREMENT PRIMARY KEY,
    auction_id  INT NOT NULL,
    buyer_id    INT NOT NULL,
    trans_time  DATETIME NOT NULL,
    status      VARCHAR(20) NOT NULL,
    UNIQUE (auction_id),
    CONSTRAINT fk_trans_auction
        FOREIGN KEY (auction_id) REFERENCES Auction(auction_id),
    CONSTRAINT fk_trans_buyer
        FOREIGN KEY (buyer_id) REFERENCES `User`(user_id)
);

CREATE TABLE Bid (
    bid_no      INT NOT NULL AUTO_INCREMENT,
    auction_id  INT NOT NULL,
    status      VARCHAR(20) NOT NULL,
    amount      DECIMAL(10,2) NOT NULL,
    bid_time    DATETIME NOT NULL,
    auto_bid    TINYINT(1) NOT NULL DEFAULT 0,
    max_bid     DECIMAL(10,2),
    buyer_id    INT NOT NULL,
    rep_id      INT,
    reason      VARCHAR(100),
    remove_date DATETIME,
    PRIMARY KEY (bid_no, auction_id),
    CONSTRAINT fk_bid_auction
        FOREIGN KEY (auction_id) REFERENCES Auction(auction_id),
    CONSTRAINT fk_bid_buyer
        FOREIGN KEY (buyer_id) REFERENCES `User`(user_id),
    CONSTRAINT fk_bid_rep
        FOREIGN KEY (rep_id) REFERENCES Cust_Rep(rep_id)
);

CREATE TABLE Alert (
    alert_id   INT AUTO_INCREMENT PRIMARY KEY,
    min_price  DECIMAL(10,2),
    max_price  DECIMAL(10,2) NOT NULL,
    keyword    VARCHAR(10),
    active     VARCHAR(20) NOT NULL,
    user_id    INT NOT NULL,
    item_id    INT NOT NULL,
    CONSTRAINT fk_alert_user
        FOREIGN KEY (user_id) REFERENCES `User`(user_id),
    CONSTRAINT fk_alert_item
        FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

CREATE TABLE Question (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    title       VARCHAR(20) NOT NULL,
    contents    VARCHAR(50) NOT NULL,
    status      VARCHAR(20) NOT NULL,
    date_asked  DATETIME NOT NULL,
    user_id     INT NOT NULL,
    reply       VARCHAR(100),
    rep_id      INT,
    CONSTRAINT fk_question_user
        FOREIGN KEY (user_id) REFERENCES `User`(user_id),
    CONSTRAINT fk_question_rep
        FOREIGN KEY (rep_id) REFERENCES Cust_Rep(rep_id)
);
