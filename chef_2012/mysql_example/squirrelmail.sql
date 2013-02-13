CREATE TABLE `mailfilter` (
      `username` varchar(150) NOT NULL default '',
      `contents` longtext NOT NULL,
      `pending_read` tinyint(4) NOT NULL default '0',
      PRIMARY KEY  (`username`),
      KEY `pending_read` (`pending_read`)
) ENGINE=InnoDB;
