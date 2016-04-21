DROP TABLE IF EXISTS `message`;
DROP TABLE IF EXISTS `follower`;
DROP TABLE IF EXISTS `connection`;
DROP TABLE IF EXISTS `profileVisit`;
DROP TABLE IF EXISTS `commentLike`;
DROP TABLE IF EXISTS `comment`;
DROP TABLE IF EXISTS `postLike`;
DROP TABLE IF EXISTS `post`;
DROP TABLE IF EXISTS `endorsement`;
DROP TABLE IF EXISTS `skill`;
DROP TABLE IF EXISTS `employment`;
DROP TABLE IF EXISTS `companyVisit`;
DROP TABLE IF EXISTS `company`;
DROP TABLE IF EXISTS `userReport`;
DROP TABLE IF EXISTS `userBlock`;
DROP TABLE IF EXISTS `user`;
DROP TABLE IF EXISTS `image`;
DROP TABLE IF EXISTS `file`;

CREATE TABLE `file` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    path varchar(60) NOT NULL UNIQUE
) ENGINE=INNODB;

CREATE TABLE `image` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    path varchar(200) NOT NULL UNIQUE
) ENGINE=INNODB;

INSERT INTO `image` VALUES
    ('Image-1', DEFAULT, 'http://www.thelandofshadow.com/wp-content/uploads/2015/09/FrodoTurns.jpg'),
    ('Image-2', DEFAULT, 'http://i1.kym-cdn.com/entries/icons/original/000/016/212/manning.png'),
    ('Image-3', DEFAULT, 'http://rs862.pbsrc.com/albums/ab186/samus_69/angus.gif~c200'),
    ('Image-4', DEFAULT, 'http://culturainternet.com/wp-content/uploads/2012/06/Adele-200x200.jpg'),
    ('Image-5', DEFAULT, 'http://cdn.macrumors.com/article-new/2015/02/Steve-Jobs-200x200.png'),
    ('Image-6', DEFAULT, 'http://s3-us-west-1.amazonaws.com/blogs-prod-media/us/uploads/2016/02/14085217/Ryan-Reynolds-daughter-200x200.jpg'),
    ('Image-7', DEFAULT, 'http://www.entrepreneurhof.com/img/john_schnatter.jpg'),
    ('Image-8', DEFAULT, 'https://img.grouponcdn.com/coupons/s6CAoyNusnjdz9ftWFXeP9/order_papajohns_com-500x500/v1/t200x200.png'),
    ('Image-9', DEFAULT, 'http://www.allaboutjazz.com/photos/news/applelogo.png');

CREATE TABLE `user` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    username varchar(15) NOT NULL UNIQUE,
    password varchar(256) NOT NULL,
    firstName varchar(15) NOT NULL,
    lastName varchar(15) NOT NULL,
    email varchar(30),
    phoneNumber varchar(15),
    birthday datetime,
    secretQuestion varchar(50),
    secretAnswer varchar(12),
    creditCardNumber char(16),
    isPremium bool NOT NULL DEFAULT FALSE,
    profileImageId varchar(36),
    resumeFileId varchar(36),
    sessionId varchar(128),
    /* priveleges, sessionId */
    FOREIGN KEY (profileImageId) REFERENCES image (id),
    FOREIGN KEY (resumeFileId) REFERENCES file (id)
) ENGINE=INNODB;

/* Note: we can use UUID() to generate UUIDs with SQL -- need hardcoded ones for the seed data though */
INSERT INTO `user` VALUES
    ('User-1', DEFAULT, 'User-1', '$2y$10$zyA.69mIxRC.vQzfAFTw8OomZIedqFAYggKy9jzrECwTmz5D50iie', 'Frodo',  'Baggins',  'frodo.baggins@theshire.net', '111-111-1111', NULL, NULL, NULL, NULL, FALSE, 'Image-1', NULL, NULL),
    ('User-2', DEFAULT, 'User-2', '$2y$10$zyA.69mIxRC.vQzfAFTw8OomZIedqFAYggKy9jzrECwTmz5D50iie', 'Peyton', 'Manning',  'bestqbevernohgh@aol.com',    '222-222-2222', NULL, NULL, NULL, NULL, FALSE, 'Image-2', NULL, NULL),
    ('User-3', DEFAULT, 'User-3', '$2y$10$zyA.69mIxRC.vQzfAFTw8OomZIedqFAYggKy9jzrECwTmz5D50iie', 'Angus',  'Young',    'angusyoung@hell.com',        '333-333-3333', NULL, NULL, NULL, NULL, FALSE, 'Image-3', NULL, NULL),
    ('User-4', DEFAULT, 'User-4', '$2y$10$zyA.69mIxRC.vQzfAFTw8OomZIedqFAYggKy9jzrECwTmz5D50iie', 'Adele',  'Adkins',   'hello@theotherside.com',     '444-444-4444', NULL, NULL, NULL, NULL, FALSE, 'Image-4', NULL, NULL),
    ('User-5', DEFAULT, 'User-5', '$2y$10$zyA.69mIxRC.vQzfAFTw8OomZIedqFAYggKy9jzrECwTmz5D50iie', 'Steve',  'Jobs',     'stevejobs@outlook.com',      '555-555-5555', NULL, NULL, NULL, NULL, FALSE, 'Image-5', NULL, NULL),
    ('User-6', DEFAULT, 'User-6', '$2y$10$zyA.69mIxRC.vQzfAFTw8OomZIedqFAYggKy9jzrECwTmz5D50iie', 'Ryan',   'Reynolds', 'dead@pool.com',              '666-666-6666', NULL, NULL, NULL, NULL, FALSE, 'Image-6', NULL, NULL),
    ('User-7', DEFAULT, 'User-7', '$2y$10$zyA.69mIxRC.vQzfAFTw8OomZIedqFAYggKy9jzrECwTmz5D50iie', 'Papa',   'John',     'papajohn@papajohns.com',     '777-777-7777', NULL, NULL, NULL, NULL, FALSE, 'Image-7', NULL, NULL);
    
CREATE TABLE `userReport` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    originUserId varchar(36) NOT NULL,
    destinationUserId varchar(36) NOT NULL,
    message varchar(100) NOT NULL,
    FOREIGN KEY (originUserId) REFERENCES user (id),
    FOREIGN KEY (destinationUserId) REFERENCES user (id),
    UNIQUE (originUserId, destinationUserId)
) ENGINE=INNODB;

CREATE TABLE `userBlock` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    originUserId varchar(36) NOT NULL,
    destinationUserId varchar(36) NOT NULL,
    FOREIGN KEY (originUserId) REFERENCES user (id),
    FOREIGN KEY (destinationUserId) REFERENCES user (id),
    UNIQUE (originUserId, destinationUserId)
) ENGINE=INNODB;

CREATE TABLE `message` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    originUserId varchar(36) NOT NULL,
    destinationUserId varchar(36) NOT NULL,
    message varchar(300) NOT NULL,
    FOREIGN KEY (originUserId) REFERENCES user (id),
    FOREIGN KEY (destinationUserId) REFERENCES user (id)
) ENGINE=INNODB;

INSERT INTO `message` VALUES
    ('Message-1', DEFAULT, 'User-1', 'User-2', 'hi'),
    ('Message-2', DEFAULT, 'User-2', 'User-1', 'hey'),
    ('Message-3', DEFAULT, 'User-1', 'User-2', 'what\'s, up?'),
    ('Message-4', DEFAULT, 'User-2', 'User-1', 'nothin. you?'),
    ('Message-5', DEFAULT, 'User-1', 'User-2', 'nothin');

CREATE TABLE `follower` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    originUserId varchar(36) NOT NULL,
    destinationUserId varchar(36) NOT NULL,
    FOREIGN KEY (originUserId) REFERENCES user (id),
    FOREIGN KEY (destinationUserId) REFERENCES user (id)
) ENGINE=INNODB;

INSERT INTO `follower` VALUES
    ('Follower-1', DEFAULT, 'User-1', 'User-2'),
    ('Follower-2', DEFAULT, 'User-1', 'User-3'),
    ('Follower-3', DEFAULT, 'User-2', 'User-5'),
    ('Follower-4', DEFAULT, 'User-2', 'User-1'),
    ('Follower-5', DEFAULT, 'User-3', 'User-6'),
    ('Follower-6', DEFAULT, 'User-4', 'User-2'),
    ('Follower-7', DEFAULT, 'User-4', 'User-3'),
    ('Follower-8', DEFAULT, 'User-5', 'User-4'),
    ('Follower-9', DEFAULT, 'User-5', 'User-1'),
    ('Follower-10', DEFAULT, 'User-6', 'User-5'),
    ('Follower-11', DEFAULT, 'User-6', 'User-2'),
    ('Follower-12', DEFAULT, 'User-6', 'User-4');

CREATE TABLE `connection` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    originUserId varchar(36) NOT NULL,
    destinationUserId varchar(36) NOT NULL,
    /* status */
    FOREIGN KEY (originUserId) REFERENCES user (id),
    FOREIGN KEY (destinationUserId) REFERENCES user (id),
    UNIQUE (originUserId, destinationUserId)
) ENGINE=INNODB;

INSERT INTO `connection` VALUES
    ('Connection-1', DEFAULT, 'User-1', 'User-2'),
    ('Connection-2', DEFAULT, 'User-1', 'User-3'),
    ('Connection-3', DEFAULT, 'User-3', 'User-6'),
    ('Connection-4', DEFAULT, 'User-4', 'User-2'),
    ('Connection-5', DEFAULT, 'User-5', 'User-4'),
    ('Connection-6', DEFAULT, 'User-5', 'User-1');

CREATE TABLE `profileVisit` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    originUserId varchar(36) NOT NULL,
    destinationUserId varchar(36) NOT NULL,
    FOREIGN KEY (originUserId) REFERENCES user (id),
    FOREIGN KEY (destinationUserId) REFERENCES user (id),
    UNIQUE (originUserId, destinationUserId)
) ENGINE=INNODB;

INSERT INTO `profileVisit` VALUES
    ('ProfileVisit-1', DEFAULT, 'User-1', 'User-2'),
    ('ProfileVisit-2', DEFAULT, 'User-1', 'User-4'),
    ('ProfileVisit-3', DEFAULT, 'User-2', 'User-6'),
    ('ProfileVisit-4', DEFAULT, 'User-2', 'User-1'),
    ('ProfileVisit-5', DEFAULT, 'User-2', 'User-3'),
    ('ProfileVisit-6', DEFAULT, 'User-3', 'User-2'),
    ('ProfileVisit-7', DEFAULT, 'User-3', 'User-1'),
    ('ProfileVisit-8', DEFAULT, 'User-3', 'User-5'),
    ('ProfileVisit-9', DEFAULT, 'User-4', 'User-6'),
    ('ProfileVisit-10', DEFAULT, 'User-4', 'User-3'),
    ('ProfileVisit-11', DEFAULT, 'User-4', 'User-5'),
    ('ProfileVisit-12', DEFAULT, 'User-5', 'User-1'),
    ('ProfileVisit-13', DEFAULT, 'User-5', 'User-2'),
    ('ProfileVisit-14', DEFAULT, 'User-5', 'User-4'),
    ('ProfileVisit-15', DEFAULT, 'User-6', 'User-3'),
    ('ProfileVisit-16', DEFAULT, 'User-6', 'User-5');
    
CREATE TABLE `company` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    name varchar(100) NOT NULL,
    birthday datetime,
    managerUserId varchar(36) NOT NULL,
    profileImageId varchar(36),
    creditCardNumber char(16),
    isPremium bool NOT NULL DEFAULT FALSE,
    FOREIGN KEY (managerUserId) REFERENCES user (id),
    FOREIGN KEY (profileImageId) REFERENCES image (id)
) ENGINE=INNODB;

INSERT INTO `company` VALUES
    ('Company-1', DEFAULT, 'Papa Johns', NULL, 'User-7', 'Image-8', '0000000000000000', false),
    ('Company-2', DEFAULT, 'Apple',      NULL, 'User-5', 'Image-9', '1111111111111111', true);

CREATE TABLE `employment` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    companyId varchar(36) NOT NULL,
    userId varchar(36) NOT NULL,
    startedAt datetime,
    endedAt datetime,
    title varchar (30),
    FOREIGN KEY (companyId) REFERENCES company (id),
    FOREIGN KEY (userId) REFERENCES user (id),
    UNIQUE (companyId, userId)
) ENGINE=INNODB;

INSERT INTO `employment` VALUES
    ('Employment-1', DEFAULT, 'Company-1', 'User-7', NULL, NULL, 'CEO'),
    ('Employment-2', DEFAULT, 'Company-1', 'User-2', NULL, NULL, 'Commercial guy'),
    ('Employment-3', DEFAULT, 'Company-2', 'User-5', NULL, NULL, 'CEO');

CREATE TABLE `companyVisit` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    companyId varchar(36) NOT NULL,
    originUserId varchar(36) NOT NULL,
    FOREIGN KEY (companyId) REFERENCES company (id),
    FOREIGN KEY (originUserId) REFERENCES user (id),
    UNIQUE(companyId, originUserId)
) ENGINE=INNODB;

INSERT INTO `companyVisit` VALUES
    ('CompanyVisit-1', DEFAULT, 'Company-1', 'User-2'),
    ('CompanyVisit-2', DEFAULT, 'Company-1', 'User-6'),
    ('CompanyVisit-3', DEFAULT, 'Company-2', 'User-4');

CREATE TABLE `post` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    originUserId varchar(36),
    originCompanyId varchar(36),
    comment varchar(800) NOT NULL,
    link varchar(150),
    FOREIGN KEY (originUserId) REFERENCES user (id),
    FOREIGN KEY (originCompanyId) REFERENCES company (id)
) ENGINE=INNODB;

INSERT INTO `post` VALUES
    ('Post-1', DEFAULT, 'User-1', NULL, 'Get HookedUp, you fools!', NULL),
    ('Post-2', DEFAULT, 'User-2', NULL, 'After a long career, which I am grateful for, I am announcing my retirement.', NULL),
    ('Post-3', DEFAULT, 'User-6', NULL, 'Boop', NULL),
    ('Post-4', '2016-01-01 12:12:12', NULL, 'Company-1', 'Come get a slice today! It\'s 50% off!', NULL),
    ('Post-5', '2016-02-04 20:20:12', NULL, 'Company-1', 'Blues win! Free Pizza for everyone!', NULL),
    ('Post-6', DEFAULT, NULL, 'Company-1', 'Try our new thin crust Buffalo Ranch Pizza', NULL),
    ('Post-7', '2015-12-12 20:24:55', NULL, 'Company-1', 'Come get a slice today! It\'s 50% off!', NULL);

CREATE TABLE `postLike` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    postId varchar(36) NOT NULL,
    originUserId varchar(36) NOT NULL,
    FOREIGN KEY (postId) REFERENCES post (id),
    FOREIGN KEY (originUserId) REFERENCES user (id),
    UNIQUE (postId, originUserId)
) ENGINE=INNODB;

INSERT INTO `postLike` VALUES
    ('PostLike-1', DEFAULT, 'Post-1', 'User-2'),
    ('PostLike-2', DEFAULT, 'Post-1', 'User-4'),
    ('PostLike-3', DEFAULT, 'Post-1', 'User-5'),
    ('PostLike-4', DEFAULT, 'Post-2', 'User-1'),
    ('PostLike-5', DEFAULT, 'Post-2', 'User-5'),
    ('PostLike-6', DEFAULT, 'Post-3', 'User-6');

CREATE TABLE `comment` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    postId varchar(36) NOT NULL,
    originUserId varchar(36) NOT NULL,
    message varchar(150) NOT NULL,
    FOREIGN KEY (postId) REFERENCES post (id),
    FOREIGN KEY (originUserId) REFERENCES user (id)
) ENGINE=INNODB;

INSERT INTO `comment` VALUES
    ('Comment-1', DEFAULT, 'Post-2', 'User-4', 'Wow!! Sad to see you go :('),
    ('Comment-2', DEFAULT, 'Post-3', 'User-6', 'Boop');
    
CREATE TABLE `commentLike` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    commentId varchar(36) NOT NULL,
    originUserId varchar(36) NOT NULL,
    FOREIGN KEY (commentId) REFERENCES comment (id),
    FOREIGN KEY (originUserId) REFERENCES user (id),
    UNIQUE (commentId, originUserId)
) ENGINE=INNODB;

INSERT INTO `commentLike` VALUES
    ('CommentLike-1', DEFAULT, 'Comment-2', 'User-6');

CREATE TABLE `skill` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    originUserId varchar(36) NOT NULL,
    name varchar(40) NOT NULL,
    FOREIGN KEY (originUserId) REFERENCES user (id)
) ENGINE=INNODB;

INSERT INTO `skill` VALUES
    ('Skill-1', DEFAULT, 'User-1', 'Eating'),
    ('Skill-2', DEFAULT, 'User-1', 'Sneaking'),
    ('Skill-3', DEFAULT, 'User-1', 'Destroying Rings'),
    ('Skill-4', DEFAULT, 'User-2', 'Football'),
    ('Skill-5', DEFAULT, 'User-2', 'Quarterbacking'),
    ('Skill-6', DEFAULT, 'User-2', 'Pizza'),
    ('Skill-7', DEFAULT, 'User-2', 'Commercials'),
    ('Skill-8', DEFAULT, 'User-3', 'Guitar'),
    ('Skill-9', DEFAULT, 'User-3', 'Riffs'),
    ('Skill-10', DEFAULT, 'User-3', 'Solos'),
    ('Skill-11', DEFAULT, 'User-4', 'Singing'),
    ('Skill-12', DEFAULT, 'User-4', 'Song Writing'),
    ('Skill-13', DEFAULT, 'User-4', 'Vocals'),
    ('Skill-14', DEFAULT, 'User-5', 'Computers'),
    ('Skill-15', DEFAULT, 'User-5', 'Management'),
    ('Skill-16', DEFAULT, 'User-5', 'Business'),
    ('Skill-17', DEFAULT, 'User-6', 'Nice butt'),
    ('Skill-18', DEFAULT, 'User-6', 'Being sexy'),
    ('Skill-19', DEFAULT, 'User-6', 'Acting'),
    ('Skill-20', DEFAULT, 'User-6', 'Commedy');

CREATE TABLE `endorsement` (
    id varchar(36) NOT NULL PRIMARY KEY,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    skillId varchar(36) NOT NULL,
    originUserId varchar(36) NOT NULL,
    FOREIGN KEY (skillId) REFERENCES skill (id),
    FOREIGN KEY (originUserId) REFERENCES user (id),
    UNIQUE (skillId, originUserId)
) ENGINE=INNODB;

INSERT INTO `endorsement` VALUES
    ('Endorsement-1', DEFAULT, 'Skill-3', 'User-2'),
    ('Endorsement-2', DEFAULT, 'Skill-3', 'User-6'),
    ('Endorsement-3', DEFAULT, 'Skill-2', 'User-6'),
    ('Endorsement-4', DEFAULT, 'Skill-6', 'User-1'),
    ('Endorsement-5', DEFAULT, 'Skill-6', 'User-6'),
    ('Endorsement-6', DEFAULT, 'Skill-4', 'User-5'),
    ('Endorsement-7', DEFAULT, 'Skill-5', 'User-5'),
    ('Endorsement-8', DEFAULT, 'Skill-8', 'User-2'),
    ('Endorsement-9', DEFAULT, 'Skill-9', 'User-2'),
    ('Endorsement-10', DEFAULT, 'Skill-10', 'User-2'),
    ('Endorsement-11', DEFAULT, 'Skill-11', 'User-3'),
    ('Endorsement-12', DEFAULT, 'Skill-12', 'User-3'),
    ('Endorsement-13', DEFAULT, 'Skill-13', 'User-3');