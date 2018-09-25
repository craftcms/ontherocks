#
# SQL Export
# Created by Querious (201042)
# Created: September 24, 2018 at 2:01:27 PM GMT+2
# Encoding: Unicode (UTF-8)
#


SET @PREVIOUS_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;


DROP TABLE IF EXISTS `widgets`;
DROP TABLE IF EXISTS `volumefolders`;
DROP TABLE IF EXISTS `volumes`;
DROP TABLE IF EXISTS `userpreferences`;
DROP TABLE IF EXISTS `userpermissions_users`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `userpermissions_usergroups`;
DROP TABLE IF EXISTS `userpermissions`;
DROP TABLE IF EXISTS `usergroups_users`;
DROP TABLE IF EXISTS `usergroups`;
DROP TABLE IF EXISTS `tokens`;
DROP TABLE IF EXISTS `templatecachequeries`;
DROP TABLE IF EXISTS `templatecacheelements`;
DROP TABLE IF EXISTS `templatecaches`;
DROP TABLE IF EXISTS `tags`;
DROP TABLE IF EXISTS `taggroups`;
DROP TABLE IF EXISTS `systemsettings`;
DROP TABLE IF EXISTS `systemmessages`;
DROP TABLE IF EXISTS `supertableblocks`;
DROP TABLE IF EXISTS `supertableblocktypes`;
DROP TABLE IF EXISTS `structureelements`;
DROP TABLE IF EXISTS `structures`;
DROP TABLE IF EXISTS `stc_ingredients`;
DROP TABLE IF EXISTS `sitegroups`;
DROP TABLE IF EXISTS `shunnedmessages`;
DROP TABLE IF EXISTS `sessions`;
DROP TABLE IF EXISTS `sections_sites`;
DROP TABLE IF EXISTS `sections`;
DROP TABLE IF EXISTS `searchindex`;
DROP TABLE IF EXISTS `routes`;
DROP TABLE IF EXISTS `sites`;
DROP TABLE IF EXISTS `resourcepaths`;
DROP TABLE IF EXISTS `relations`;
DROP TABLE IF EXISTS `recipe_reactions`;
DROP TABLE IF EXISTS `queue`;
DROP TABLE IF EXISTS `migrations`;
DROP TABLE IF EXISTS `plugins`;
DROP TABLE IF EXISTS `matrixblocks`;
DROP TABLE IF EXISTS `matrixblocktypes`;
DROP TABLE IF EXISTS `info`;
DROP TABLE IF EXISTS `globalsets`;
DROP TABLE IF EXISTS `fieldlayoutfields`;
DROP TABLE IF EXISTS `fields`;
DROP TABLE IF EXISTS `fieldlayouttabs`;
DROP TABLE IF EXISTS `fieldgroups`;
DROP TABLE IF EXISTS `entryversions`;
DROP TABLE IF EXISTS `entrytypes`;
DROP TABLE IF EXISTS `fieldlayouts`;
DROP TABLE IF EXISTS `entrydrafts`;
DROP TABLE IF EXISTS `entries`;
DROP TABLE IF EXISTS `elements_sites`;
DROP TABLE IF EXISTS `elementindexsettings`;
DROP TABLE IF EXISTS `deprecationerrors`;
DROP TABLE IF EXISTS `craftidtokens`;
DROP TABLE IF EXISTS `content`;
DROP TABLE IF EXISTS `categorygroups_sites`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `categorygroups`;
DROP TABLE IF EXISTS `assettransforms`;
DROP TABLE IF EXISTS `assettransformindex`;
DROP TABLE IF EXISTS `assets`;
DROP TABLE IF EXISTS `elements`;
DROP TABLE IF EXISTS `assetindexdata`;


CREATE TABLE `assetindexdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sessionId` varchar(36) NOT NULL DEFAULT '',
  `volumeId` int(11) NOT NULL,
  `uri` text,
  `size` bigint(20) unsigned DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `recordId` int(11) DEFAULT NULL,
  `inProgress` tinyint(1) DEFAULT '0',
  `completed` tinyint(1) DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `assetindexdata_sessionId_volumeId_idx` (`sessionId`,`volumeId`),
  KEY `assetindexdata_volumeId_idx` (`volumeId`),
  CONSTRAINT `assetindexdata_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `archived` tinyint(1) NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `elements_fieldLayoutId_idx` (`fieldLayoutId`),
  KEY `elements_type_idx` (`type`),
  KEY `elements_enabled_idx` (`enabled`),
  KEY `elements_archived_dateCreated_idx` (`archived`,`dateCreated`),
  CONSTRAINT `elements_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=192 DEFAULT CHARSET=utf8;


CREATE TABLE `assets` (
  `id` int(11) NOT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `folderId` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `kind` varchar(50) NOT NULL DEFAULT 'unknown',
  `width` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `size` bigint(20) unsigned DEFAULT NULL,
  `focalPoint` varchar(13) DEFAULT NULL,
  `dateModified` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `assets_filename_folderId_unq_idx` (`filename`,`folderId`),
  KEY `assets_folderId_idx` (`folderId`),
  KEY `assets_volumeId_idx` (`volumeId`),
  CONSTRAINT `assets_folderId_fk` FOREIGN KEY (`folderId`) REFERENCES `volumefolders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `assets_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `assets_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `assettransformindex` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assetId` int(11) NOT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `location` varchar(255) NOT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `fileExists` tinyint(1) NOT NULL DEFAULT '0',
  `inProgress` tinyint(1) NOT NULL DEFAULT '0',
  `dateIndexed` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `assettransformindex_volumeId_assetId_location_idx` (`volumeId`,`assetId`,`location`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;


CREATE TABLE `assettransforms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `mode` enum('stretch','fit','crop') NOT NULL DEFAULT 'crop',
  `position` enum('top-left','top-center','top-right','center-left','center-center','center-right','bottom-left','bottom-center','bottom-right') NOT NULL DEFAULT 'center-center',
  `width` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `quality` int(11) DEFAULT NULL,
  `interlace` enum('none','line','plane','partition') NOT NULL DEFAULT 'none',
  `dimensionChangeTime` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `assettransforms_name_unq_idx` (`name`),
  UNIQUE KEY `assettransforms_handle_unq_idx` (`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `categorygroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `categorygroups_name_unq_idx` (`name`),
  UNIQUE KEY `categorygroups_handle_unq_idx` (`handle`),
  KEY `categorygroups_structureId_idx` (`structureId`),
  KEY `categorygroups_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `categorygroups_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `categorygroups_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `structures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `categories_groupId_idx` (`groupId`),
  CONSTRAINT `categories_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `categorygroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `categories_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `categorygroups_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `uriFormat` text,
  `template` varchar(500) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `categorygroups_sites_groupId_siteId_unq_idx` (`groupId`,`siteId`),
  KEY `categorygroups_sites_siteId_idx` (`siteId`),
  CONSTRAINT `categorygroups_sites_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `categorygroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `categorygroups_sites_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  `field_description` text,
  `field_directions` text,
  `field_location` varchar(255) DEFAULT NULL,
  `field_glass` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_elementId_siteId_unq_idx` (`elementId`,`siteId`),
  KEY `content_siteId_idx` (`siteId`),
  KEY `content_title_idx` (`title`),
  CONSTRAINT `content_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `content_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8;


CREATE TABLE `craftidtokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `accessToken` text NOT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craftidtokens_userId_fk` (`userId`),
  CONSTRAINT `craftidtokens_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `deprecationerrors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `fingerprint` varchar(255) NOT NULL,
  `lastOccurrence` datetime NOT NULL,
  `file` varchar(255) NOT NULL,
  `line` smallint(6) unsigned DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `traces` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `deprecationerrors_key_fingerprint_unq_idx` (`key`,`fingerprint`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `elementindexsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `elementindexsettings_type_unq_idx` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;


CREATE TABLE `elements_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `uri` varchar(255) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `elements_sites_elementId_siteId_unq_idx` (`elementId`,`siteId`),
  KEY `elements_sites_siteId_idx` (`siteId`),
  KEY `elements_sites_slug_siteId_idx` (`slug`,`siteId`),
  KEY `elements_sites_enabled_idx` (`enabled`),
  KEY `elements_sites_uri_siteId_idx` (`uri`,`siteId`),
  CONSTRAINT `elements_sites_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `elements_sites_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=192 DEFAULT CHARSET=utf8;


CREATE TABLE `entries` (
  `id` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `typeId` int(11) NOT NULL,
  `authorId` int(11) DEFAULT NULL,
  `postDate` datetime DEFAULT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `entries_postDate_idx` (`postDate`),
  KEY `entries_expiryDate_idx` (`expiryDate`),
  KEY `entries_authorId_idx` (`authorId`),
  KEY `entries_sectionId_idx` (`sectionId`),
  KEY `entries_typeId_idx` (`typeId`),
  CONSTRAINT `entries_authorId_fk` FOREIGN KEY (`authorId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entries_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entries_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entries_typeId_fk` FOREIGN KEY (`typeId`) REFERENCES `entrytypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `entrydrafts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `creatorId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `notes` text,
  `data` mediumtext NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `entrydrafts_sectionId_idx` (`sectionId`),
  KEY `entrydrafts_entryId_siteId_idx` (`entryId`,`siteId`),
  KEY `entrydrafts_siteId_idx` (`siteId`),
  KEY `entrydrafts_creatorId_idx` (`creatorId`),
  CONSTRAINT `entrydrafts_creatorId_fk` FOREIGN KEY (`creatorId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entrydrafts_entryId_fk` FOREIGN KEY (`entryId`) REFERENCES `entries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entrydrafts_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entrydrafts_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `fieldlayouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fieldlayouts_type_idx` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;


CREATE TABLE `entrytypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sectionId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `hasTitleField` tinyint(1) NOT NULL DEFAULT '1',
  `titleLabel` varchar(255) DEFAULT 'Title',
  `titleFormat` varchar(255) DEFAULT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `entrytypes_name_sectionId_unq_idx` (`name`,`sectionId`),
  UNIQUE KEY `entrytypes_handle_sectionId_unq_idx` (`handle`,`sectionId`),
  KEY `entrytypes_sectionId_idx` (`sectionId`),
  KEY `entrytypes_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `entrytypes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `entrytypes_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


CREATE TABLE `entryversions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `creatorId` int(11) DEFAULT NULL,
  `siteId` int(11) NOT NULL,
  `num` smallint(6) unsigned NOT NULL,
  `notes` text,
  `data` mediumtext NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `entryversions_sectionId_idx` (`sectionId`),
  KEY `entryversions_entryId_siteId_idx` (`entryId`,`siteId`),
  KEY `entryversions_siteId_idx` (`siteId`),
  KEY `entryversions_creatorId_idx` (`creatorId`),
  CONSTRAINT `entryversions_creatorId_fk` FOREIGN KEY (`creatorId`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `entryversions_entryId_fk` FOREIGN KEY (`entryId`) REFERENCES `entries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entryversions_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entryversions_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `fieldgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `fieldgroups_name_unq_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


CREATE TABLE `fieldlayouttabs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `layoutId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fieldlayouttabs_sortOrder_idx` (`sortOrder`),
  KEY `fieldlayouttabs_layoutId_idx` (`layoutId`),
  CONSTRAINT `fieldlayouttabs_layoutId_fk` FOREIGN KEY (`layoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;


CREATE TABLE `fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(64) NOT NULL,
  `context` varchar(255) NOT NULL DEFAULT 'global',
  `instructions` text,
  `translationMethod` varchar(255) NOT NULL DEFAULT 'none',
  `translationKeyFormat` text,
  `type` varchar(255) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `fields_handle_context_unq_idx` (`handle`,`context`),
  KEY `fields_groupId_idx` (`groupId`),
  KEY `fields_context_idx` (`context`),
  CONSTRAINT `fields_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `fieldgroups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;


CREATE TABLE `fieldlayoutfields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `layoutId` int(11) NOT NULL,
  `tabId` int(11) NOT NULL,
  `fieldId` int(11) NOT NULL,
  `required` tinyint(1) NOT NULL DEFAULT '0',
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `fieldlayoutfields_layoutId_fieldId_unq_idx` (`layoutId`,`fieldId`),
  KEY `fieldlayoutfields_sortOrder_idx` (`sortOrder`),
  KEY `fieldlayoutfields_tabId_idx` (`tabId`),
  KEY `fieldlayoutfields_fieldId_idx` (`fieldId`),
  CONSTRAINT `fieldlayoutfields_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fieldlayoutfields_layoutId_fk` FOREIGN KEY (`layoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fieldlayoutfields_tabId_fk` FOREIGN KEY (`tabId`) REFERENCES `fieldlayouttabs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;


CREATE TABLE `globalsets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `globalsets_name_unq_idx` (`name`),
  UNIQUE KEY `globalsets_handle_unq_idx` (`handle`),
  KEY `globalsets_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `globalsets_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `globalsets_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` varchar(50) NOT NULL,
  `schemaVersion` varchar(15) NOT NULL,
  `edition` tinyint(3) unsigned NOT NULL,
  `timezone` varchar(30) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `on` tinyint(1) NOT NULL DEFAULT '0',
  `maintenance` tinyint(1) NOT NULL DEFAULT '0',
  `fieldVersion` char(12) NOT NULL DEFAULT '000000000000',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `matrixblocktypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `matrixblocktypes_name_fieldId_unq_idx` (`name`,`fieldId`),
  UNIQUE KEY `matrixblocktypes_handle_fieldId_unq_idx` (`handle`,`fieldId`),
  KEY `matrixblocktypes_fieldId_idx` (`fieldId`),
  KEY `matrixblocktypes_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `matrixblocktypes_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `matrixblocktypes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `matrixblocks` (
  `id` int(11) NOT NULL,
  `ownerId` int(11) NOT NULL,
  `ownerSiteId` int(11) DEFAULT NULL,
  `fieldId` int(11) NOT NULL,
  `typeId` int(11) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `matrixblocks_ownerId_idx` (`ownerId`),
  KEY `matrixblocks_fieldId_idx` (`fieldId`),
  KEY `matrixblocks_typeId_idx` (`typeId`),
  KEY `matrixblocks_sortOrder_idx` (`sortOrder`),
  KEY `matrixblocks_ownerSiteId_idx` (`ownerSiteId`),
  CONSTRAINT `matrixblocks_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `matrixblocks_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `matrixblocks_ownerId_fk` FOREIGN KEY (`ownerId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `matrixblocks_ownerSiteId_fk` FOREIGN KEY (`ownerSiteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `matrixblocks_typeId_fk` FOREIGN KEY (`typeId`) REFERENCES `matrixblocktypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `plugins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `handle` varchar(255) NOT NULL,
  `version` varchar(255) NOT NULL,
  `schemaVersion` varchar(255) NOT NULL,
  `licenseKey` char(24) DEFAULT NULL,
  `licenseKeyStatus` enum('valid','invalid','mismatched','astray','unknown') NOT NULL DEFAULT 'unknown',
  `enabled` tinyint(1) NOT NULL DEFAULT '0',
  `settings` text,
  `installDate` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `plugins_handle_unq_idx` (`handle`),
  KEY `plugins_enabled_idx` (`enabled`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


CREATE TABLE `migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pluginId` int(11) DEFAULT NULL,
  `type` enum('app','plugin','content') NOT NULL DEFAULT 'app',
  `name` varchar(255) NOT NULL,
  `applyTime` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `migrations_pluginId_idx` (`pluginId`),
  KEY `migrations_type_pluginId_idx` (`type`,`pluginId`),
  CONSTRAINT `migrations_pluginId_fk` FOREIGN KEY (`pluginId`) REFERENCES `plugins` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8;


CREATE TABLE `queue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job` longblob NOT NULL,
  `description` text,
  `timePushed` int(11) NOT NULL,
  `ttr` int(11) NOT NULL,
  `delay` int(11) NOT NULL DEFAULT '0',
  `priority` int(11) unsigned NOT NULL DEFAULT '1024',
  `dateReserved` datetime DEFAULT NULL,
  `timeUpdated` int(11) DEFAULT NULL,
  `progress` smallint(6) NOT NULL DEFAULT '0',
  `attempt` int(11) DEFAULT NULL,
  `fail` tinyint(1) DEFAULT '0',
  `dateFailed` datetime DEFAULT NULL,
  `error` text,
  PRIMARY KEY (`id`),
  KEY `queue_fail_timeUpdated_timePushed_idx` (`fail`,`timeUpdated`,`timePushed`),
  KEY `queue_fail_timeUpdated_delay_idx` (`fail`,`timeUpdated`,`delay`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `recipe_reactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `recipeId` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `reaction` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `recipe_reactions_recipeId_userId_reaction_unq_idx` (`recipeId`,`userId`,`reaction`),
  KEY `recipe_reactions_userId_fk` (`userId`),
  CONSTRAINT `recipe_reactions_recipeId_fk` FOREIGN KEY (`recipeId`) REFERENCES `entries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `recipe_reactions_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldId` int(11) NOT NULL,
  `sourceId` int(11) NOT NULL,
  `sourceSiteId` int(11) DEFAULT NULL,
  `targetId` int(11) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `relations_fieldId_sourceId_sourceSiteId_targetId_unq_idx` (`fieldId`,`sourceId`,`sourceSiteId`,`targetId`),
  KEY `relations_sourceId_idx` (`sourceId`),
  KEY `relations_targetId_idx` (`targetId`),
  KEY `relations_sourceSiteId_idx` (`sourceSiteId`),
  CONSTRAINT `relations_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `relations_sourceId_fk` FOREIGN KEY (`sourceId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `relations_sourceSiteId_fk` FOREIGN KEY (`sourceSiteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `relations_targetId_fk` FOREIGN KEY (`targetId`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=190 DEFAULT CHARSET=utf8;


CREATE TABLE `resourcepaths` (
  `hash` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  PRIMARY KEY (`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `primary` tinyint(1) NOT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `language` varchar(12) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '0',
  `baseUrl` varchar(255) DEFAULT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sites_handle_unq_idx` (`handle`),
  KEY `sites_sortOrder_idx` (`sortOrder`),
  KEY `sites_groupId_fk` (`groupId`),
  CONSTRAINT `sites_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `sitegroups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `siteId` int(11) DEFAULT NULL,
  `uriParts` varchar(255) NOT NULL,
  `uriPattern` varchar(255) NOT NULL,
  `template` varchar(500) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `routes_uriPattern_idx` (`uriPattern`),
  KEY `routes_siteId_idx` (`siteId`),
  CONSTRAINT `routes_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `searchindex` (
  `elementId` int(11) NOT NULL,
  `attribute` varchar(25) NOT NULL,
  `fieldId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `keywords` text NOT NULL,
  PRIMARY KEY (`elementId`,`attribute`,`fieldId`,`siteId`),
  FULLTEXT KEY `searchindex_keywords_idx` (`keywords`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `type` enum('single','channel','structure') NOT NULL DEFAULT 'channel',
  `enableVersioning` tinyint(1) NOT NULL DEFAULT '0',
  `propagateEntries` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sections_handle_unq_idx` (`handle`),
  UNIQUE KEY `sections_name_unq_idx` (`name`),
  KEY `sections_structureId_idx` (`structureId`),
  CONSTRAINT `sections_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `structures` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


CREATE TABLE `sections_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sectionId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `uriFormat` text,
  `template` varchar(500) DEFAULT NULL,
  `enabledByDefault` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sections_sites_sectionId_siteId_unq_idx` (`sectionId`,`siteId`),
  KEY `sections_sites_siteId_idx` (`siteId`),
  CONSTRAINT `sections_sites_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sections_sites_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `token` char(100) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `sessions_uid_idx` (`uid`),
  KEY `sessions_token_idx` (`token`),
  KEY `sessions_dateUpdated_idx` (`dateUpdated`),
  KEY `sessions_userId_idx` (`userId`),
  CONSTRAINT `sessions_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `shunnedmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shunnedmessages_userId_message_unq_idx` (`userId`,`message`),
  CONSTRAINT `shunnedmessages_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `sitegroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sitegroups_name_unq_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `stc_ingredients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  `field_label` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `stc_ingredients_elementId_siteId_unq_idx` (`elementId`,`siteId`),
  KEY `stc_ingredients_siteId_fk` (`siteId`),
  CONSTRAINT `stc_ingredients_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `stc_ingredients_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8;


CREATE TABLE `structures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `maxLevels` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `structureelements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) NOT NULL,
  `elementId` int(11) DEFAULT NULL,
  `root` int(11) unsigned DEFAULT NULL,
  `lft` int(11) unsigned NOT NULL,
  `rgt` int(11) unsigned NOT NULL,
  `level` smallint(6) unsigned NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `structureelements_structureId_elementId_unq_idx` (`structureId`,`elementId`),
  KEY `structureelements_root_idx` (`root`),
  KEY `structureelements_lft_idx` (`lft`),
  KEY `structureelements_rgt_idx` (`rgt`),
  KEY `structureelements_level_idx` (`level`),
  KEY `structureelements_elementId_idx` (`elementId`),
  CONSTRAINT `structureelements_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `structureelements_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `structures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `supertableblocktypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `supertableblocktypes_fieldId_idx` (`fieldId`),
  KEY `supertableblocktypes_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `supertableblocktypes_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `supertableblocktypes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `supertableblocks` (
  `id` int(11) NOT NULL,
  `ownerId` int(11) NOT NULL,
  `ownerSiteId` int(11) DEFAULT NULL,
  `fieldId` int(11) NOT NULL,
  `typeId` int(11) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `supertableblocks_ownerId_idx` (`ownerId`),
  KEY `supertableblocks_fieldId_idx` (`fieldId`),
  KEY `supertableblocks_typeId_idx` (`typeId`),
  KEY `supertableblocks_ownerSiteId_idx` (`ownerSiteId`),
  CONSTRAINT `supertableblocks_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `supertableblocks_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `supertableblocks_ownerId_fk` FOREIGN KEY (`ownerId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `supertableblocks_ownerSiteId_fk` FOREIGN KEY (`ownerSiteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `supertableblocks_typeId_fk` FOREIGN KEY (`typeId`) REFERENCES `supertableblocktypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `systemmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language` varchar(255) NOT NULL,
  `key` varchar(255) NOT NULL,
  `subject` text NOT NULL,
  `body` text NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `systemmessages_key_language_unq_idx` (`key`,`language`),
  KEY `systemmessages_language_idx` (`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `systemsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(15) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `systemsettings_category_unq_idx` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


CREATE TABLE `taggroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `taggroups_name_unq_idx` (`name`),
  UNIQUE KEY `taggroups_handle_unq_idx` (`handle`),
  KEY `taggroups_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `taggroups_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `tags` (
  `id` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tags_groupId_idx` (`groupId`),
  CONSTRAINT `tags_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `taggroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tags_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `templatecaches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `siteId` int(11) NOT NULL,
  `cacheKey` varchar(255) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `expiryDate` datetime NOT NULL,
  `body` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `templatecaches_cacheKey_siteId_expiryDate_path_idx` (`cacheKey`,`siteId`,`expiryDate`,`path`),
  KEY `templatecaches_cacheKey_siteId_expiryDate_idx` (`cacheKey`,`siteId`,`expiryDate`),
  KEY `templatecaches_siteId_idx` (`siteId`),
  CONSTRAINT `templatecaches_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `templatecacheelements` (
  `cacheId` int(11) NOT NULL,
  `elementId` int(11) NOT NULL,
  KEY `templatecacheelements_cacheId_idx` (`cacheId`),
  KEY `templatecacheelements_elementId_idx` (`elementId`),
  CONSTRAINT `templatecacheelements_cacheId_fk` FOREIGN KEY (`cacheId`) REFERENCES `templatecaches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `templatecacheelements_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `templatecachequeries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cacheId` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `query` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `templatecachequeries_cacheId_idx` (`cacheId`),
  KEY `templatecachequeries_type_idx` (`type`),
  CONSTRAINT `templatecachequeries_cacheId_fk` FOREIGN KEY (`cacheId`) REFERENCES `templatecaches` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` char(32) NOT NULL,
  `route` text,
  `usageLimit` tinyint(3) unsigned DEFAULT NULL,
  `usageCount` tinyint(3) unsigned DEFAULT NULL,
  `expiryDate` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tokens_token_unq_idx` (`token`),
  KEY `tokens_expiryDate_idx` (`expiryDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `usergroups_handle_unq_idx` (`handle`),
  UNIQUE KEY `usergroups_name_unq_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


CREATE TABLE `usergroups_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `usergroups_users_groupId_userId_unq_idx` (`groupId`,`userId`),
  KEY `usergroups_users_userId_idx` (`userId`),
  CONSTRAINT `usergroups_users_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `usergroups_users_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;


CREATE TABLE `userpermissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userpermissions_name_unq_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;


CREATE TABLE `userpermissions_usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permissionId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userpermissions_usergroups_permissionId_groupId_unq_idx` (`permissionId`,`groupId`),
  KEY `userpermissions_usergroups_groupId_idx` (`groupId`),
  CONSTRAINT `userpermissions_usergroups_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `userpermissions_usergroups_permissionId_fk` FOREIGN KEY (`permissionId`) REFERENCES `userpermissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;


CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `photoId` int(11) DEFAULT NULL,
  `firstName` varchar(100) DEFAULT NULL,
  `lastName` varchar(100) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  `locked` tinyint(1) NOT NULL DEFAULT '0',
  `suspended` tinyint(1) NOT NULL DEFAULT '0',
  `pending` tinyint(1) NOT NULL DEFAULT '0',
  `lastLoginDate` datetime DEFAULT NULL,
  `lastLoginAttemptIp` varchar(45) DEFAULT NULL,
  `invalidLoginWindowStart` datetime DEFAULT NULL,
  `invalidLoginCount` tinyint(3) unsigned DEFAULT NULL,
  `lastInvalidLoginDate` datetime DEFAULT NULL,
  `lockoutDate` datetime DEFAULT NULL,
  `hasDashboard` tinyint(1) NOT NULL DEFAULT '0',
  `verificationCode` varchar(255) DEFAULT NULL,
  `verificationCodeIssuedDate` datetime DEFAULT NULL,
  `unverifiedEmail` varchar(255) DEFAULT NULL,
  `passwordResetRequired` tinyint(1) NOT NULL DEFAULT '0',
  `lastPasswordChangeDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `users_uid_idx` (`uid`),
  KEY `users_verificationCode_idx` (`verificationCode`),
  KEY `users_email_idx` (`email`),
  KEY `users_username_idx` (`username`),
  KEY `users_photoId_fk` (`photoId`),
  CONSTRAINT `users_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `users_photoId_fk` FOREIGN KEY (`photoId`) REFERENCES `assets` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `userpermissions_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permissionId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userpermissions_users_permissionId_userId_unq_idx` (`permissionId`,`userId`),
  KEY `userpermissions_users_userId_idx` (`userId`),
  CONSTRAINT `userpermissions_users_permissionId_fk` FOREIGN KEY (`permissionId`) REFERENCES `userpermissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `userpermissions_users_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `userpreferences` (
  `userId` int(11) NOT NULL AUTO_INCREMENT,
  `preferences` text,
  PRIMARY KEY (`userId`),
  CONSTRAINT `userpreferences_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=191 DEFAULT CHARSET=utf8;


CREATE TABLE `volumes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `url` varchar(255) DEFAULT NULL,
  `settings` text,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `volumes_name_unq_idx` (`name`),
  UNIQUE KEY `volumes_handle_unq_idx` (`handle`),
  KEY `volumes_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `volumes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


CREATE TABLE `volumefolders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentId` int(11) DEFAULT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `volumefolders_name_parentId_volumeId_unq_idx` (`name`,`parentId`,`volumeId`),
  KEY `volumefolders_parentId_idx` (`parentId`),
  KEY `volumefolders_volumeId_idx` (`volumeId`),
  CONSTRAINT `volumefolders_parentId_fk` FOREIGN KEY (`parentId`) REFERENCES `volumefolders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `volumefolders_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;


CREATE TABLE `widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `colspan` tinyint(1) NOT NULL DEFAULT '0',
  `settings` text,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `widgets_userId_idx` (`userId`),
  CONSTRAINT `widgets_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;




SET FOREIGN_KEY_CHECKS = @PREVIOUS_FOREIGN_KEY_CHECKS;


SET @PREVIOUS_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;


LOCK TABLES `assetindexdata` WRITE;
ALTER TABLE `assetindexdata` DISABLE KEYS;
ALTER TABLE `assetindexdata` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `elements` WRITE;
ALTER TABLE `elements` DISABLE KEYS;
INSERT INTO `elements` (`id`, `fieldLayoutId`, `type`, `enabled`, `archived`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,6,'craft\\elements\\User',1,0,'2018-09-18 20:53:52','2018-09-24 00:18:39','a3633c9c-148d-4784-9ee4-e29e349339a0'),
	(4,2,'craft\\elements\\Entry',1,0,'2018-09-19 10:28:34','2018-09-23 23:11:23','29b397cd-7446-4c71-a134-de3b33fa8dc3'),
	(6,2,'craft\\elements\\Entry',1,0,'2018-09-19 10:30:01','2018-09-23 23:11:23','1cbfabe5-6735-4641-a438-a4a647941267'),
	(8,2,'craft\\elements\\Entry',1,0,'2018-09-19 10:32:53','2018-09-23 23:11:23','1b589d81-6d82-45a3-b3ce-a656d4545035'),
	(9,5,'craft\\elements\\Entry',1,0,'2018-09-19 10:35:43','2018-09-24 00:17:22','ff31dd21-7cad-4677-8f40-ef710de6cfe8'),
	(12,3,'craft\\elements\\Asset',1,0,'2018-09-19 10:37:23','2018-09-20 21:12:14','42be1c29-5fee-46b3-8cff-74c1f2223741'),
	(13,5,'craft\\elements\\Entry',1,0,'2018-09-19 10:37:38','2018-09-22 03:55:31','554fd46c-c03f-4a7b-b5c8-00a773078103'),
	(16,3,'craft\\elements\\Asset',1,0,'2018-09-19 10:38:42','2018-09-20 21:12:02','d70d541a-d6d9-4c05-b1bc-d2fc0ebef800'),
	(17,5,'craft\\elements\\Entry',1,0,'2018-09-20 05:47:11','2018-09-22 03:53:49','d96165a2-9c1a-4276-a554-4303d49060bf'),
	(18,3,'craft\\elements\\Asset',1,0,'2018-09-20 09:20:19','2018-09-20 21:11:37','8b3ac6b9-d998-4911-8cfb-f64f05e0dd5c'),
	(19,2,'craft\\elements\\Entry',1,0,'2018-09-20 09:20:55','2018-09-23 23:11:23','e47d009b-58e1-4261-8979-143cd62a1341'),
	(25,3,'craft\\elements\\Asset',1,0,'2018-09-20 21:15:56','2018-09-20 21:21:46','c6af84ad-9bc6-4e04-a6b4-d8bfddf06b5d'),
	(26,3,'craft\\elements\\Asset',1,0,'2018-09-20 21:16:01','2018-09-20 21:46:41','4401a74d-fd57-45ca-a75a-06bdfcb7048b'),
	(27,3,'craft\\elements\\Asset',1,0,'2018-09-20 21:16:06','2018-09-20 21:55:06','026b923f-a9d5-4f38-84b4-34a68fd52d81'),
	(28,3,'craft\\elements\\Asset',1,0,'2018-09-20 21:16:12','2018-09-20 22:05:04','14140a62-9d1a-4f8e-8675-964b0d2d204c'),
	(29,3,'craft\\elements\\Asset',1,0,'2018-09-20 21:16:16','2018-09-20 22:05:50','4fe4595f-52db-42e6-9ee8-de7377f175f4'),
	(30,3,'craft\\elements\\Asset',1,0,'2018-09-20 21:16:19','2018-09-20 22:14:22','213dd034-9d67-4301-8ef0-23ea1ed32104'),
	(31,3,'craft\\elements\\Asset',1,0,'2018-09-20 21:16:23','2018-09-20 22:16:03','4155d209-ea53-4e87-9c87-b0c8ec19ab31'),
	(32,3,'craft\\elements\\Asset',1,0,'2018-09-20 21:16:27','2018-09-20 22:19:30','7e9cc73d-13db-4bee-8f98-12015a5624b3'),
	(33,3,'craft\\elements\\Asset',1,0,'2018-09-20 21:16:34','2018-09-20 22:24:54','885edef2-a247-4823-bc51-25b531d774c3'),
	(34,3,'craft\\elements\\Asset',1,0,'2018-09-20 21:16:37','2018-09-20 22:28:19','7264d612-369e-41d3-b3bd-c63c7c4e39af'),
	(37,5,'craft\\elements\\Entry',1,0,'2018-09-20 21:24:15','2018-09-22 03:52:56','1fae0633-b3a9-47f1-b3be-933099f959ee'),
	(40,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 21:29:33','2018-09-22 03:52:56','80d008b3-76e3-42d4-b8d7-89ca37d3ccba'),
	(41,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 21:29:33','2018-09-22 03:52:56','4ae55ebc-3d99-4c7c-91e9-fecb021de286'),
	(42,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 21:30:01','2018-09-22 03:53:49','4aa5fb11-788a-41ba-a1a1-1f3032efca32'),
	(43,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 21:30:01','2018-09-22 03:53:49','88d9aed2-4ad8-4faf-8b01-8f0d96f5ffa4'),
	(44,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 21:30:25','2018-09-22 03:55:32','6a3c2dd6-453e-4b18-b785-e9e806671665'),
	(45,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 21:30:25','2018-09-22 03:55:32','931c681b-bba0-45ac-b2fa-87a99bc17da5'),
	(46,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 21:30:58','2018-09-24 00:17:23','298160b1-ca4e-4759-b1b6-a1556aad44a1'),
	(47,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 21:30:58','2018-09-24 00:17:23','cc93393d-40ee-4bc6-b148-7e3583a8ea73'),
	(48,5,'craft\\elements\\Entry',1,0,'2018-09-20 21:50:46','2018-09-22 03:52:35','d064e06c-7462-4484-bcc6-f9e2109fa8f3'),
	(49,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 21:50:46','2018-09-22 03:52:35','6552e448-fba0-435c-b137-d41dfe691bfd'),
	(50,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 21:50:46','2018-09-22 03:52:35','ddfae946-b71f-449c-8876-176d8eb92263'),
	(51,5,'craft\\elements\\Entry',1,0,'2018-09-20 21:59:33','2018-09-23 23:18:55','f4b8df02-30ee-4dba-8bc6-21ee2aecf7a0'),
	(52,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 21:59:34','2018-09-23 23:18:55','acb88185-b28b-45e6-86d8-d39e150a59a7'),
	(53,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 21:59:34','2018-09-23 23:18:55','035f12c0-ca16-4a3d-913d-d5e4f48421ef'),
	(54,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 21:59:34','2018-09-23 23:18:55','312f3ff3-72fb-438b-93c9-431dcc78ab83'),
	(55,5,'craft\\elements\\Entry',1,0,'2018-09-20 22:05:14','2018-09-22 03:58:27','90ee7b75-943b-4073-8810-0d6c4a343ecf'),
	(56,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:05:14','2018-09-22 03:58:27','1d774995-bfd1-488e-8325-e9a4b0be557b'),
	(57,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:05:14','2018-09-22 03:58:27','1d96c8c9-4962-4fd4-8ebb-12df23f3af27'),
	(58,5,'craft\\elements\\Entry',1,0,'2018-09-20 22:09:38','2018-09-22 03:50:49','23423175-094d-4ed3-9a83-2d94aeb8b170'),
	(59,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:09:38','2018-09-22 03:50:49','1b2028a4-76ef-4436-a25e-ed0a51b70be4'),
	(60,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:09:39','2018-09-22 03:50:49','c4a015c0-a294-44cb-8f23-97576741aa1d'),
	(61,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:09:39','2018-09-22 03:50:49','42b7325f-08c5-4246-bc40-4b09604181e8'),
	(62,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:09:39','2018-09-22 03:50:49','1fbcfe75-f452-4181-b10f-c342cecb8fe3'),
	(63,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:09:39','2018-09-22 03:50:49','66c380bf-97bc-430b-aef8-a5ad12c01d78'),
	(64,5,'craft\\elements\\Entry',1,0,'2018-09-20 22:14:46','2018-09-23 23:18:13','cbd340d8-a199-4972-9a43-481a1e2ab810'),
	(65,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:14:46','2018-09-23 23:18:13','44bc5803-7697-4105-9e8e-d55b7976f86e'),
	(66,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:14:46','2018-09-23 23:18:13','992f321d-749f-4fdd-b21a-32cc1972f583'),
	(67,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:14:46','2018-09-23 23:18:13','70b78f23-b107-4f13-9e84-49f8a9600246'),
	(68,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:14:46','2018-09-23 23:18:13','3e199eb9-f2e6-422a-ad7c-2a8fdff8a8a4'),
	(69,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:14:46','2018-09-23 23:18:13','37ff9e50-e50d-43e6-87b0-1ffc2b0c06a8'),
	(70,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:14:46','2018-09-23 23:18:13','16f03f65-c2f6-4884-9f0f-2ee6edd003ad'),
	(71,5,'craft\\elements\\Entry',1,0,'2018-09-20 22:18:27','2018-09-23 23:17:09','c714a995-9665-4161-9529-58dcb6843c36'),
	(72,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:18:27','2018-09-23 23:17:09','d90ba855-a982-487b-91f6-f3e8d775c5a2'),
	(73,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:18:27','2018-09-23 23:17:09','8e422e72-ddbc-4ed5-ad24-32e3bda3606a'),
	(74,5,'craft\\elements\\Entry',1,0,'2018-09-20 22:22:34','2018-09-24 00:17:40','fcca7d04-119d-4fa0-a53e-a8656a8fea08'),
	(75,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:22:34','2018-09-24 00:17:40','249c08e1-2b20-4a48-ab8e-2c74f191e8e2'),
	(76,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:22:34','2018-09-24 00:17:40','b31675a5-6219-43e7-a8b7-bcd17ebbe2c1'),
	(77,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:22:34','2018-09-24 00:17:40','c496c3b1-4626-4cd3-ac8b-ee7088308362'),
	(79,5,'craft\\elements\\Entry',1,0,'2018-09-20 22:27:18','2018-09-23 23:16:19','9ca3e6cf-f0e6-4742-b748-ffaed4fd7fbd'),
	(80,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:27:18','2018-09-23 23:16:19','0daaa28c-3833-4bc7-bfe8-837224cc746c'),
	(81,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:27:18','2018-09-23 23:16:19','cdd7c7e5-a5c6-44ae-beb9-df712173dc33'),
	(82,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:27:18','2018-09-23 23:16:19','3221fb16-4f78-4904-a682-76787c22baaf'),
	(83,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:27:18','2018-09-23 23:16:19','41c6f223-82ac-4ce7-a003-210c1b9e39e3'),
	(84,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:27:18','2018-09-23 23:16:19','5cae0c77-f5b4-4be2-980e-44c449fb15f8'),
	(85,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:27:18','2018-09-23 23:16:19','43c1273d-70e1-4d8b-83f4-044216056865'),
	(86,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:27:18','2018-09-23 23:16:19','151e122b-1d39-4554-aa17-df98ff4b5ad4'),
	(87,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:27:18','2018-09-23 23:16:19','2b58ef42-c637-43d2-855d-8350786e3d50'),
	(88,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:27:18','2018-09-23 23:16:19','a2a15ba2-c406-4eb2-b9b1-2e4bae379ec0'),
	(89,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:27:18','2018-09-23 23:16:19','0a633052-8105-4b1a-b101-8b1ea5488c3c'),
	(90,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:27:18','2018-09-23 23:16:19','37d0333e-08c7-4c7c-ab3d-73015e9308c5'),
	(91,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:27:18','2018-09-23 23:16:19','8a7c80d4-8a6a-4cf0-a07d-03f69a6a61df'),
	(92,5,'craft\\elements\\Entry',1,0,'2018-09-20 22:30:34','2018-09-23 23:14:09','b34b3f38-d2c6-4242-b691-66dda85259df'),
	(93,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:30:35','2018-09-23 23:14:09','bf00368f-490e-4289-9a72-796bb9ad40c8'),
	(94,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:30:35','2018-09-23 23:14:09','01955b1c-d06e-4381-9bb7-8011eb96b976'),
	(95,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 22:30:35','2018-09-23 23:14:09','a6292e83-6ab9-4ea7-b819-741ba8b87434'),
	(96,3,'craft\\elements\\Asset',1,0,'2018-09-20 23:47:17','2018-09-20 23:53:57','35626f22-f0ae-4e55-bb82-95817481311b'),
	(97,3,'craft\\elements\\Asset',1,0,'2018-09-20 23:47:20','2018-09-20 23:50:33','0205ebc5-00b6-4178-a07b-258d924ceaa0'),
	(98,5,'craft\\elements\\Entry',1,0,'2018-09-20 23:50:50','2018-09-23 23:13:14','0051d0e5-d0a4-4fb1-ae9f-537e7a762026'),
	(99,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 23:50:50','2018-09-23 23:13:14','5a0bbcba-f0e7-4642-a169-fbe3479c093c'),
	(100,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 23:50:50','2018-09-23 23:13:14','b2ab7a8f-c1eb-491b-ad70-36271bc8e736'),
	(101,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 23:50:50','2018-09-23 23:13:14','e39907b3-ed34-4e4a-90ea-38c1d88f3117'),
	(102,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 23:50:50','2018-09-23 23:13:14','5f2c64bd-2644-420b-833e-879bb60bf2c8'),
	(103,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 23:50:50','2018-09-23 23:13:14','d83a36f0-3c83-44b7-9456-1578e2fa52c6'),
	(104,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-20 23:50:50','2018-09-23 23:13:14','9b33c621-bad6-4a9b-956e-a3b9d883717b'),
	(105,5,'craft\\elements\\Entry',1,0,'2018-09-20 23:53:08','2018-09-24 00:17:33','9ed2a4d5-1df0-4541-8d26-37fcc5194478'),
	(155,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-21 17:07:51','2018-09-24 00:17:33','428861fc-c7ae-4c1c-b915-fadc26667375'),
	(156,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-21 17:07:51','2018-09-24 00:17:33','9c4d7562-818d-47b2-a550-c17da63f304e'),
	(157,7,'verbb\\supertable\\elements\\SuperTableBlockElement',1,0,'2018-09-21 17:07:51','2018-09-24 00:17:33','66c0b955-3f3e-46d4-a4f7-17be63b5c3cc'),
	(162,6,'craft\\elements\\User',1,0,'2018-09-22 03:40:35','2018-09-24 00:16:17','5861a6c8-58a3-4a24-a632-7d0489af10ac'),
	(163,1,'craft\\elements\\Asset',1,0,'2018-09-22 03:40:39','2018-09-22 03:40:39','e6d4b96b-6b9f-415f-9d40-d2a8d9773274'),
	(164,6,'craft\\elements\\User',1,0,'2018-09-22 03:41:04','2018-09-22 03:44:52','49dcbde1-2cb8-4040-88a2-c21da4002b97'),
	(165,1,'craft\\elements\\Asset',1,0,'2018-09-22 03:41:10','2018-09-22 03:41:10','9eb63422-d97b-46f7-9754-7e5bdc17c395'),
	(166,6,'craft\\elements\\User',1,0,'2018-09-22 03:41:34','2018-09-22 03:41:51','73b6bed1-f7a5-4251-8ecb-51bcd95476b3'),
	(167,1,'craft\\elements\\Asset',1,0,'2018-09-22 03:41:49','2018-09-22 03:41:49','519d04ec-a0f1-4252-9fba-942ff09bd3b5'),
	(168,6,'craft\\elements\\User',1,0,'2018-09-22 03:42:35','2018-09-22 03:44:56','2a2579c0-72fe-4397-86c9-bccc30facc08'),
	(169,1,'craft\\elements\\Asset',1,0,'2018-09-22 03:42:51','2018-09-22 03:42:55','2a1d30ce-0067-4311-b5e3-d0ba84495b9c'),
	(170,6,'craft\\elements\\User',1,0,'2018-09-22 03:43:35','2018-09-22 03:56:18','6c686edf-ebb8-486a-a90f-decf9e95b3e4'),
	(171,1,'craft\\elements\\Asset',1,0,'2018-09-22 03:43:44','2018-09-22 03:43:44','51d54699-9f24-4fe5-8d76-d03a8f207915'),
	(172,6,'craft\\elements\\User',1,0,'2018-09-22 03:44:13','2018-09-22 03:45:06','ca5a6e8d-b492-41a4-ad12-f31e72876cc0'),
	(173,1,'craft\\elements\\Asset',1,0,'2018-09-22 03:44:20','2018-09-22 03:44:20','5037c677-ecbd-4df4-8f48-77d91ead90fe'),
	(174,2,'craft\\elements\\Entry',1,0,'2018-09-23 23:10:06','2018-09-23 23:11:23','f4ecedc9-516a-4c35-96df-2b3ff6b0cbdb'),
	(175,2,'craft\\elements\\Entry',1,0,'2018-09-23 23:12:45','2018-09-23 23:12:45','af4bb139-d57a-4198-92dd-9693d0be59f9'),
	(176,2,'craft\\elements\\Entry',1,0,'2018-09-23 23:12:58','2018-09-23 23:12:58','a2249a53-fc22-4a72-a51b-758d5537606f'),
	(177,2,'craft\\elements\\Entry',1,0,'2018-09-23 23:13:35','2018-09-23 23:13:35','9c699050-a515-4d00-b3a5-7962aa2a1e7e'),
	(178,2,'craft\\elements\\Entry',1,0,'2018-09-23 23:13:53','2018-09-23 23:13:53','76d1768e-5005-4343-ae07-899b10a34bd4'),
	(179,2,'craft\\elements\\Entry',1,0,'2018-09-23 23:14:19','2018-09-23 23:14:19','699d3d99-e321-4c44-8696-1e16cd388352'),
	(180,2,'craft\\elements\\Entry',1,0,'2018-09-23 23:14:45','2018-09-23 23:14:45','f1bc56a0-8e14-42bc-9067-8f357369f888'),
	(181,2,'craft\\elements\\Entry',1,0,'2018-09-23 23:14:58','2018-09-23 23:14:58','d0335fd6-8525-47a9-8b55-7918a615f821'),
	(182,2,'craft\\elements\\Entry',1,0,'2018-09-23 23:15:35','2018-09-23 23:15:35','c0468053-e78d-4e69-887c-c1d9938eac55'),
	(183,2,'craft\\elements\\Entry',1,0,'2018-09-23 23:16:32','2018-09-23 23:16:32','21dc3b63-3608-40a2-af2f-b263714d1cda'),
	(184,2,'craft\\elements\\Entry',1,0,'2018-09-23 23:16:43','2018-09-23 23:16:43','30434a51-7104-4332-aec1-5f0f2f3cf3dc'),
	(185,2,'craft\\elements\\Entry',1,0,'2018-09-23 23:16:59','2018-09-23 23:16:59','a5a91069-b290-4b40-a698-ff0e7130644f'),
	(186,2,'craft\\elements\\Entry',1,0,'2018-09-23 23:17:31','2018-09-23 23:17:31','fa5331dd-2fbe-425f-b865-7bd1bfe81b39'),
	(187,2,'craft\\elements\\Entry',1,0,'2018-09-23 23:18:37','2018-09-23 23:18:37','18673003-dd91-43a7-99c9-a62c7f3661d7'),
	(190,6,'craft\\elements\\User',1,0,'2018-09-24 00:15:03','2018-09-24 00:15:11','45dacb85-9c6b-41e7-bed5-8e33668bd005'),
	(191,1,'craft\\elements\\Asset',1,0,'2018-09-24 00:15:08','2018-09-24 00:15:08','c904a1f3-f447-488c-8783-94fa9bb1a182');
ALTER TABLE `elements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `assets` WRITE;
ALTER TABLE `assets` DISABLE KEYS;
INSERT INTO `assets` (`id`, `volumeId`, `folderId`, `filename`, `kind`, `width`, `height`, `size`, `focalPoint`, `dateModified`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(12,2,4,'vodka-tonic.jpg','image',4608,3072,5036537,'0.5523;0.4753','2018-09-20 21:11:42','2018-09-19 10:37:26','2018-09-20 21:12:14','52c27533-7b54-4c13-8be8-9ced80ae28ac'),
	(16,2,4,'gin-and-tonic.jpg','image',5211,3474,7452137,'0.7830;0.4601','2018-09-20 21:11:36','2018-09-19 10:38:43','2018-09-20 21:12:02','0d93153e-bc3e-4e7a-8933-f487a3076c3f'),
	(18,2,4,'salty-dog.jpg','image',3168,4752,5700605,'0.6318;0.3747','2018-09-20 21:11:39','2018-09-20 09:20:19','2018-09-20 21:11:39','ff66defb-02be-43f4-8bb0-8ae21f296a91'),
	(25,2,4,'apple-cider.jpg','image',5760,3840,8417554,'0.6019;0.4804','2018-09-20 21:15:59','2018-09-20 21:16:00','2018-09-20 21:21:46','4ad6f4d2-f1ee-4d1c-a479-7b8d4cd0d65a'),
	(26,2,4,'arnold-palmer.jpg','image',5760,3840,9780674,'0.6861;0.2478','2018-09-20 21:16:04','2018-09-20 21:16:05','2018-09-20 21:46:41','4648ee2b-5fb6-4264-9d40-35b9da817dce'),
	(27,2,4,'irish-coffee.jpg','image',6000,4000,2720454,'0.5648;0.2613','2018-09-20 21:55:07','2018-09-20 21:16:12','2018-09-20 21:55:08','dc3b5396-659c-4ce0-bf7f-7a4a6911f50f'),
	(28,2,4,'lemonade.jpg','image',4288,2848,6473725,'0.8880;0.4604','2018-09-20 21:16:15','2018-09-20 21:16:15','2018-09-20 22:05:04','1acd5074-1bfd-45e0-b442-b63f107ac6af'),
	(29,2,4,'lemondrop.jpg','image',3872,2592,6843622,'0.6424;0.3965','2018-09-20 21:16:18','2018-09-20 21:16:18','2018-09-20 22:05:50','8f168ac5-63b3-46a8-a445-f554534cdbf0'),
	(30,2,4,'margarita.jpg','image',4500,3269,1063205,'0.5546;0.3295','2018-09-20 22:14:00','2018-09-20 21:16:22','2018-09-20 22:14:22','359f3a8a-4c18-450a-93ef-abc7ccf03788'),
	(31,2,4,'mimosa.jpg','image',5616,3744,8057030,'0.6469;0.4143','2018-09-20 21:16:26','2018-09-20 21:16:27','2018-09-20 22:16:03','3db467ec-0a91-421d-8a00-e5a6d0e7cec9'),
	(32,2,4,'old-fashioned.jpg','image',6000,4000,2244171,'0.6495;0.3614','2018-09-20 22:19:14','2018-09-20 21:16:33','2018-09-20 22:19:30','80637a81-02a5-4800-93f3-3e6d4af05506'),
	(33,2,4,'sangria.jpg','image',4334,3605,6842149,'0.6779;0.5812','2018-09-20 21:16:36','2018-09-20 21:16:37','2018-09-20 22:24:54','099dc85d-2d13-49f1-8165-4f633094dddc'),
	(34,2,4,'aperol-spritz.jpg','image',6000,4000,12639701,'0.7060;0.4432','2018-09-20 21:16:42','2018-09-20 21:16:43','2018-09-20 22:28:19','fd4834ab-dcbb-4d1b-828c-82a8b5db2ba2'),
	(96,2,4,'martini.jpg','image',3872,2592,918323,'0.7081;0.5168','2018-09-21 00:45:35','2018-09-20 23:47:19','2018-09-20 23:53:57','7c4f827c-1dcc-42d2-885e-7e267a055eec'),
	(97,2,4,'mojito.jpg','image',3840,3840,5902096,'0.6675;0.4036','2018-09-21 00:39:52','2018-09-20 23:47:23','2018-09-20 23:50:33','ce62dfa5-8501-477e-9063-34bf95a8e363'),
	(163,1,1,'bjorn.jpg','image',500,500,83764,NULL,'2018-09-23 18:35:22','2018-09-22 03:40:39','2018-09-22 03:40:39','31c2efbd-c3f8-4533-b459-a5b9fa70ab1e'),
	(165,1,1,'cathie.jpg','image',500,500,74669,NULL,'2018-09-23 18:35:53','2018-09-22 03:41:10','2018-09-22 03:41:10','c6ad9eea-0f13-495f-9b2c-08046af02491'),
	(167,1,1,'dale.jpg','image',500,500,89856,NULL,'2018-09-23 18:36:32','2018-09-22 03:41:49','2018-09-22 03:41:49','c1d43dac-a7fd-4eb1-b5fe-f233c633f8ef'),
	(169,1,1,'garrett.jpg','image',500,500,67956,NULL,'2018-09-23 18:37:38','2018-09-22 03:42:51','2018-09-22 03:42:55','a2211be8-afca-4336-b189-6e4e1eb25b87'),
	(171,1,1,'tiff.jpg','image',500,500,79159,NULL,'2018-09-23 18:38:27','2018-09-22 03:43:44','2018-09-22 03:43:44','953da1b6-145e-47cf-a411-9aa8a37720bd'),
	(173,1,1,'tj.jpg','image',500,500,78835,NULL,'2018-09-23 18:39:03','2018-09-22 03:44:20','2018-09-22 03:44:20','b8db25bc-81b6-4f24-8704-524f69ca48d6'),
	(191,1,1,'veronica.jpg','image',500,500,87675,NULL,'2018-09-24 00:15:08','2018-09-24 00:15:08','2018-09-24 00:15:08','f3157de5-153b-40d1-ab8a-1964bfe4a5b8');
ALTER TABLE `assets` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `assettransformindex` WRITE;
ALTER TABLE `assettransformindex` DISABLE KEYS;
INSERT INTO `assettransformindex` (`id`, `assetId`, `filename`, `format`, `location`, `volumeId`, `fileExists`, `inProgress`, `dateIndexed`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,96,'martini.jpg',NULL,'_600x400_crop_center-center_none',2,1,0,'2018-09-24 00:12:27','2018-09-24 00:12:27','2018-09-24 00:12:56','e663317e-450b-496b-b356-94898c9d3da4'),
	(2,97,'mojito.jpg',NULL,'_600x400_crop_center-center_none',2,1,0,'2018-09-24 00:12:27','2018-09-24 00:12:27','2018-09-24 00:12:56','a5b16d34-32fc-4eaf-8953-272c433362fd'),
	(3,34,'aperol-spritz.jpg',NULL,'_600x400_crop_center-center_none',2,1,0,'2018-09-24 00:12:27','2018-09-24 00:12:27','2018-09-24 00:12:56','ba7dfb34-e0e9-443d-8a47-07946b4658da'),
	(4,33,'sangria.jpg',NULL,'_600x400_crop_center-center_none',2,1,0,'2018-09-24 00:12:27','2018-09-24 00:12:27','2018-09-24 00:12:56','baf4c2c5-2bb6-455c-9c46-e98182f6861a'),
	(5,32,'old-fashioned.jpg',NULL,'_600x400_crop_center-center_none',2,1,0,'2018-09-24 00:12:27','2018-09-24 00:12:27','2018-09-24 00:12:56','edaec583-f604-4d6d-a5a1-a939e3c89901'),
	(6,31,'mimosa.jpg',NULL,'_600x400_crop_center-center_none',2,1,0,'2018-09-24 00:12:27','2018-09-24 00:12:27','2018-09-24 00:12:56','6f53ce96-93d4-4490-a537-0717539e2b56'),
	(7,30,'margarita.jpg',NULL,'_600x400_crop_center-center_none',2,1,0,'2018-09-24 00:12:27','2018-09-24 00:12:27','2018-09-24 00:12:56','17bbc688-94b5-4422-93d9-f29c5c790468'),
	(8,29,'lemondrop.jpg',NULL,'_600x400_crop_center-center_none',2,1,0,'2018-09-24 00:12:27','2018-09-24 00:12:27','2018-09-24 00:12:56','f15fdf75-59d4-4f14-9c81-5b4ae88ffdbf'),
	(9,28,'lemonade.jpg',NULL,'_600x400_crop_center-center_none',2,1,0,'2018-09-24 00:12:27','2018-09-24 00:12:27','2018-09-24 00:12:56','a9f46bd3-77f5-4941-a607-12bfefc3c70c'),
	(10,27,'irish-coffee.jpg',NULL,'_600x400_crop_center-center_none',2,1,0,'2018-09-24 00:12:27','2018-09-24 00:12:27','2018-09-24 00:12:56','aa64a060-1baa-416d-882f-3a75f1f64018'),
	(11,26,'arnold-palmer.jpg',NULL,'_600x400_crop_center-center_none',2,1,0,'2018-09-24 00:12:27','2018-09-24 00:12:27','2018-09-24 00:12:56','6e4a4c8c-684c-4ab3-af0a-fd4e50c11731'),
	(12,25,'apple-cider.jpg',NULL,'_600x400_crop_center-center_none',2,1,0,'2018-09-24 00:12:27','2018-09-24 00:12:27','2018-09-24 00:12:56','b4334aa4-686b-4ab1-8002-c9761878f7cd'),
	(13,18,'salty-dog.jpg',NULL,'_600x400_crop_center-center_none',2,1,0,'2018-09-24 00:12:27','2018-09-24 00:12:27','2018-09-24 00:12:56','b43981b8-6a93-4060-bf96-984737a21626'),
	(14,12,'vodka-tonic.jpg',NULL,'_600x400_crop_center-center_none',2,1,0,'2018-09-24 00:12:27','2018-09-24 00:12:27','2018-09-24 00:12:56','db2c642d-f886-4152-9125-91d91e0e413a'),
	(15,16,'gin-and-tonic.jpg',NULL,'_600x400_crop_center-center_none',2,1,0,'2018-09-24 00:12:27','2018-09-24 00:12:27','2018-09-24 00:12:56','1c5b8981-2dad-4e57-858d-54e4a9568433');
ALTER TABLE `assettransformindex` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `assettransforms` WRITE;
ALTER TABLE `assettransforms` DISABLE KEYS;
ALTER TABLE `assettransforms` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `categorygroups` WRITE;
ALTER TABLE `categorygroups` DISABLE KEYS;
ALTER TABLE `categorygroups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `categories` WRITE;
ALTER TABLE `categories` DISABLE KEYS;
ALTER TABLE `categories` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `categorygroups_sites` WRITE;
ALTER TABLE `categorygroups_sites` DISABLE KEYS;
ALTER TABLE `categorygroups_sites` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `content` WRITE;
ALTER TABLE `content` DISABLE KEYS;
INSERT INTO `content` (`id`, `elementId`, `siteId`, `title`, `dateCreated`, `dateUpdated`, `uid`, `field_description`, `field_directions`, `field_location`, `field_glass`) VALUES 
	(1,1,1,NULL,'2018-09-18 20:53:52','2018-09-24 00:18:39','97372f8b-8dde-4aa1-8439-1bd232f084a7',NULL,NULL,NULL,NULL),
	(4,4,1,'Gin','2018-09-19 10:28:34','2018-09-23 23:11:23','3198f5f5-c28a-4b1c-9ade-3383aa43e7ab','<p>Gin is liquor which derives its predominant flavor from juniper berries. Gin is one of the broadest categories of spirits, all of various origins, styles, and flavor profiles that revolve around juniper as a common ingredient.</p>\n<p>From its earliest origins in the Middle Ages, the drink has evolved from a herbal medicine to an object of commerce in the spirits industry. Gin was developed based on the older Dutch liquor, jenever, and became popular in Great Britain (particularly in London) when William of Orange became King William III, II, and I of England, Scotland and Ireland.</p>',NULL,NULL,NULL),
	(6,6,1,'Vodka','2018-09-19 10:30:01','2018-09-23 23:11:23','4d96c17d-79e9-4f03-96d4-636f67c2f724','<p>Vodka is a distilled beverage composed primarily of water and ethanol, but sometimes with traces of impurities and flavorings. Traditionally, vodka is made through the distillation of cereal grains or potatoes that have been fermented, though some modern brands, such as Ciroc, CooranBong, and Bombora, use fruits or sugar.<br /></p>\n<p>Since the 1890s, the standard Polish, Russian, Belarusian, Czech, Estonian, Hungarian, Icelandic, Latvian, Lithuanian, Norwegian, Slovak, Swedish and Ukrainian vodkas are 40% ABV or alcohol by volume (80 US proof), a percentage widely misattributed to Russian chemist Dmitri Mendeleev. Meanwhile, the European Union has established a minimum of 37.5% ABV for any "European vodka" to be named as such. Products sold as "vodka" in the United States must have a minimum alcohol content of 40%. Even with these loose restrictions, most vodka sold contains 40% ABV.</p>\n<p>Vodka is traditionally drunk "neat" (not mixed with water, ice, or other mixer), though it is often served freezer chilled in the vodka belt countries of Belarus, Estonia, Finland, Iceland, Lithuania, Latvia, Norway, Poland, and Russia. It is also used in cocktails and mixed drinks, such as the Vodka martini, Cosmopolitan, Vodka Tonic, Screwdriver, Greyhound, Black or White Russian, Moscow Mule, Bloody Mary and Bloody Caesar.</p>',NULL,NULL,NULL),
	(8,8,1,'Tonic Water','2018-09-19 10:32:53','2018-09-23 23:11:23','864c16cb-0c8a-475f-be2e-e75124c6dda6','<p>Tonic water (or Indian tonic water) is a carbonated soft drink in which quinine is dissolved. Originally used as a prophylactic against malaria, tonic water usually now has a significantly lower quinine content and is consumed for its distinctive bitter flavor. It is often used in mixed drinks, particularly in gin and tonic.<br /></p>',NULL,NULL,NULL),
	(9,9,1,'Gin and Tonic','2018-09-19 10:35:43','2018-09-24 00:17:23','c08399d3-e25a-44ff-9ab7-3885664c6475','<p>A gin and tonic is a highball cocktail made with gin and tonic water poured over ice. It is usually garnished with a slice or wedge of lime. The amount of gin varies according to taste. Suggested ratios of gin to tonic are between 1:1 and 1:3.<br /></p>\n<p>In some countries (e.g. UK), gin and tonic is also marketed pre-mixed in single-serving cans. In the United States, most bars use "soda out of a gun that in no way, shape or form resembles quinine water", according to bartender Dale DeGroff. To get a real gin and tonic, DeGroff recommends specifying bottled tonic. Alternatively, one can add tonic syrup to soda water.</p>\n<p>Gin and tonic made with Bombay Sapphire London Dry Gin and Schweppes Indian Tonic, garnished with slices of lime.</p>\n<p>The drink is a particular phenomenon as its taste is quite different from the taste of its constituent liquids which are rather bitter. The chemical structures of both ingredients are of a similar molecular shape and attract each other, shielding the bitter taste.</p>\n<p>A gin and tonic with ice and lemon.</p>\n<p>It is commonly referred to as a "G and T" in the UK, US, Canada, Australia, New Zealand and Ireland.[7] In some parts of the world, it is called a "gin tonic" (e.g. Germany, Spain, the Netherlands, Japan ジン・トニック – phonetically "gin tonic"). Some brands will replace the word "gin" with their own brand or initial in recipes. For instance, "Sapphire and Tonic" for Bombay Sapphire, "Hendrick\'s and Tonic" for Hendrick\'s Gin (garnished with cucumber to further distinguish it), or "T&amp;T" for Tanqueray.</p>','[{"col1":"Combine gin and tonic water in a highball glass over ice."},{"col1":"Garnish with a lime."}]',NULL,'highball'),
	(10,12,1,'Vodka Tonic','2018-09-19 10:37:23','2018-09-20 21:12:14','f73fe0a2-2440-4f0e-b899-9688b94e198c',NULL,NULL,NULL,NULL),
	(11,13,1,'Vodka Tonic','2018-09-19 10:37:38','2018-09-22 03:55:31','7189d898-f095-4f13-8709-e4747191d6a4','<p>A vodka tonic is an alcoholic drink made with varying proportions of vodka and tonic water. Vodka tonics are frequently garnished with a slice of lime or lemon.</p>\n<p>One commonly used recipe is one part vodka and one part tonic water in a tumbler over ice, with a generous lime wedge squeezed into it.</p>\n<p>The drink is referenced in the song "Goodbye Yellow Brick Road" by Elton John.</p>','[{"col1":"Combine vodka and tonic water in a highball glass over ice"},{"col1":"Garnish with a lemon"}]',NULL,'highball'),
	(12,16,1,'Gin and Tonic','2018-09-19 10:38:42','2018-09-20 21:12:02','7e89beda-4e98-41fb-9aae-fc827341b37f',NULL,NULL,NULL,NULL),
	(13,17,1,'Salty Dog','2018-09-20 05:47:11','2018-09-22 03:53:49','130348ec-7764-4660-9eb8-d2dd40490d4b','<p>A salty dog is a cocktail of gin, or vodka, and grapefruit juice, served in a highball glass with a salted rim. The salt is the only difference between a salty dog and a greyhound. Vodka may be used as a substitute for gin; nevertheless, it is historically a gin drink.</p>','[{"col1":"Salt the rim of the glass."},{"col1":"Pour ingredients in glass over ice."},{"col1":"Garnish with a grapefruit wedge."}]',NULL,'highball'),
	(14,18,1,'Salty Dog','2018-09-20 09:20:19','2018-09-20 21:11:37','6bb6f16c-918e-41a1-9167-171ecee1c8aa',NULL,NULL,NULL,NULL),
	(15,19,1,'Grapefruit Juice','2018-09-20 09:20:55','2018-09-23 23:11:23','e7ea8878-de67-4511-94db-79ae6745f872',NULL,NULL,NULL,NULL),
	(19,25,1,'Apple Cider','2018-09-20 21:15:56','2018-09-20 21:21:46','cae4fb17-121d-43bb-9303-a4c324a302c4',NULL,NULL,NULL,NULL),
	(20,26,1,'Arnold Palmer','2018-09-20 21:16:01','2018-09-20 21:46:41','a55db19d-b344-4cb3-a2ef-998a2dcde638',NULL,NULL,NULL,NULL),
	(21,27,1,'Irish Coffee','2018-09-20 21:16:06','2018-09-20 21:55:06','4dac0f2b-c26f-47e2-9e2c-44519124bd51',NULL,NULL,NULL,NULL),
	(22,28,1,'Lemonade','2018-09-20 21:16:12','2018-09-20 22:05:04','a9533166-575a-42b4-bd34-fddc91a7869c',NULL,NULL,NULL,NULL),
	(23,29,1,'Lemondrop','2018-09-20 21:16:16','2018-09-20 22:05:50','f9a741ec-aba2-4fbc-9af9-4b9250881404',NULL,NULL,NULL,NULL),
	(24,30,1,'Margarita','2018-09-20 21:16:19','2018-09-20 22:14:22','0ad5cd25-bc6a-4e6e-9935-e3050857cfbf',NULL,NULL,NULL,NULL),
	(25,31,1,'Mimosa','2018-09-20 21:16:23','2018-09-20 22:16:03','7feb08db-dcf0-42f7-a4e9-b7158ffde098',NULL,NULL,NULL,NULL),
	(26,32,1,'Old Fashioned','2018-09-20 21:16:27','2018-09-20 22:19:30','8c8c37af-e8e7-43bb-b0da-200da4ec893e',NULL,NULL,NULL,NULL),
	(27,33,1,'Sangria','2018-09-20 21:16:34','2018-09-20 22:24:54','a1e3d138-8d7e-43f8-a7a1-3865ae7a3abb',NULL,NULL,NULL,NULL),
	(28,34,1,'Aperol Spritz','2018-09-20 21:16:37','2018-09-20 22:28:19','1214b156-e540-43b9-bbeb-2082fb44b017',NULL,NULL,NULL,NULL),
	(31,37,1,'Apple Cider','2018-09-20 21:24:15','2018-09-22 03:52:56','331d473d-1912-4c92-ba43-1259a62ab0a8','<p>Apple cider is an unfiltered, unsweetened apple juice. Most present-day apple juice is pasteurized and filtered.</p>\n<p>Apple cider (also called sweet cider or soft cider or simply cider) is the name used in the United States and parts of Canada for an unfiltered, unsweetened, non-alcoholic beverage made from apples. Though typically referred to simply as "cider" in those areas, it is not to be confused with the alcoholic beverage known as cider throughout most of the world, called hard cider (or just cider) in North America. It is the official state beverage of New Hampshire.</p>\n<p>It is the liquid extracted from an apple and all its components, that is then boiled to concentration. The liquid can be extracted from the apple itself, the apple core, the trimmings from apples, or apple culls. Once pressed mainly at farmsteads and local mills, apple cider is easy and inexpensive to make. It is typically opaque due to fine apple particles in suspension and generally tangier than commercial filtered apple juice, but this depends on the variety of apples used. Cider is typically pasteurized to kill bacteria and extend its shelf life, but untreated cider is common. In either form, apple cider is seasonally produced in autumn. It is traditionally served on the Halloween, Thanksgiving, Christmas, and various New Year\'s Eve holidays, sometimes heated and mulled.</p>','[{"col1":"Place apples in a large stockpot and add enough water cover by at least 2 inches."},{"col1":"Stir in sugar, cinnamon, and allspice."},{"col1":"Bring to a boil and boil, uncovered, for 1 hour."},{"col1":"Cover pot, reduce heat, and simmer for 2 hours."},{"col1":"Strain apple mixture though a fine mesh sieve. Discard solids. "},{"col1":"Drain cider again though a cheesecloth lined sieve."},{"col1":"Refrigerate until cold."}]',NULL,'mug'),
	(32,48,1,'Arnold Palmer','2018-09-20 21:50:46','2018-09-22 03:52:35','d26f0989-91bd-4a01-b50b-c6a8b75b406b','<p>The Arnold Palmer beverage is a non-alcoholic combination of iced tea and lemonade, created and made popular by American golfer Arnold Palmer.<br /></p>\n<p>An alcoholic version of the beverage (generally made with vodka) is often referred to as a John Daly. However, MillerCoors began marketing and distributing a commercially available malt-based version of the beverage under the Arnold Palmer Spiked name in early 2018.</p>','[{"col1":"Combine lemonade and iced tea in a highball or tall glass."},{"col1":"Add ice and stir until chilled."}]',NULL,'highball-footed'),
	(33,51,1,'Irish Coffee','2018-09-20 21:59:33','2018-09-23 23:18:55','3423eae7-6d38-4036-8adb-0288352d8cbc','<p>Irish coffee (Irish: caife Gaelach) is a cocktail consisting of hot coffee, Irish whiskey, and sugar (some recipes specify that brown sugar should be used), stirred, and topped with thick cream. The coffee is drunk through the cream. The original recipe explicitly uses cream that has not been whipped, although drinks made with whipped cream are often sold as "Irish coffee". The term "Irish coffee" is also sometimes used colloquially to refer to alcoholic coffee drinks in general.</p>','[{"col1":"In a coffee mug, combine Irish cream and Irish whiskey."},{"col1":"Fill mug with coffee."},{"col1":"Top with a dab of whipped cream and a dash of nutmeg."}]',NULL,'irish-coffee'),
	(34,55,1,'Lemonade','2018-09-20 22:05:14','2018-09-22 03:58:27','22e5e934-f03f-49d0-a29b-5a2312362793','<p>Lemonade can be any one of a variety of sweetened beverages found throughout the world, but which are all characterized by a lemon flavor.</p>\n<p>Most lemonade varieties can be separated into two distinct types: cloudy or clear; each is known simply as "lemonade" (or a cognate) in countries where dominant. Cloudy lemonade, generally found in North America and South Asia, is traditionally a homemade drink using lemon juice, water, and a sweetener such as cane sugar or honey. In the United Kingdom and Australia, clear lemonade, which is typically also carbonated, dominates.</p>\n<p>A popular cloudy variation is pink lemonade, made with added fruit flavors such as raspberry or strawberry and giving the drink its distinctive pink color. The "-ade" suffix may also be applied to other similar drinks made with different fruits, such as limeade, orangeade, or cherryade. Alcoholic varieties are known as hard lemonade.</p>','[{"col1":"In a small saucepan, combine sugar and 1 cup water."},{"col1":"Bring to boil and stir to dissolve sugar."},{"col1":"Allow to cool to room temperature, then cover and refrigerate until chilled."},{"col1":"Remove seeds from lemon juice, but leave pulp."},{"col1":"In pitcher, stir together chilled syrup, lemon juice and remaining 7 cups water."}]',NULL,'beverage'),
	(35,58,1,'Lemondrop','2018-09-20 22:09:38','2018-09-22 03:50:49','c400a073-6828-4355-b448-8fefbb2cebab','<p>A lemon drop is a vodka-based cocktail that has a lemony, sweet and sour flavor, prepared using lemon juice, triple sec and simple syrup. It has been described as a variant of, or as "a take on", the Vodka Martini. It is typically prepared and served straight up – chilled with ice and strained.<br /></p>\n<p>The drink was invented sometime in the 1970s by Norman Jay Hobday, the founder and proprietor of Henry Africa\'s bar in San Francisco, California. Some variations of the drink exist, such as blueberry and raspberry lemon drops. It is served at some bars and restaurants in the United States, and in such establishments in other areas of the world.</p>','[{"col1":"Combine the vodka, lemon juice, and sugar and pour into a cocktail shaker with ice."},{"col1":"Pour into martini glasses and garnish with lemon slices."}]',NULL,'martini'),
	(36,64,1,'Margarita','2018-09-20 22:14:46','2018-09-23 23:18:13','2ef0bcef-4552-446e-964c-354bbae51828','<p>A margarita is a cocktail consisting of tequila, orange liqueur, and lime juice often served with salt on the rim of the glass. The drink is served shaken with ice (on the rocks), blended with ice (frozen margarita), or without ice (straight up). Although it has become acceptable to serve a margarita in a wide variety of glass types, ranging from cocktail and wine glasses to pint glasses and even large schooners, the drink is traditionally served in the eponymous margarita glass, a stepped-diameter variant of a cocktail glass or champagne coupe.</p>','[{"col1":"Fill a cocktail shaker with ice."},{"col1":"Add tequila, lime juice, Simple Syrup and orange liqueur."},{"col1":"Cover and shake until mixed and chilled, about 30 seconds. (In general, the drink is ready by the time the shaker mists up.)"},{"col1":"Place Lime-salt-sugar on a plate."},{"col1":"Press the rim of a chilled rocks or wine glass into the mixture to rim the edge."},{"col1":"Strain margarita into the glass."}]',NULL,'margarita-welled'),
	(37,71,1,'Mimosa','2018-09-20 22:18:27','2018-09-23 23:17:09','f28c3e33-0e45-4d1b-a782-6d9120585523','<p>A mimosa cocktail is composed of one part champagne (or other sparkling wine) and one part chilled citrus juice, usually orange juice unless otherwise specified. It is traditionally served in a tall champagne flute at brunch, at weddings, by the pint, or as part of first class service on some passenger railways and airlines.</p>','[{"col1":"Mix three parts of your favorite sparkling white to one part of your favorite orange juice."}]',NULL,'flute'),
	(38,74,1,'Old Fashioned','2018-09-20 22:22:34','2018-09-24 00:17:40','e740d7ac-a445-4332-83d7-3917c8c46a93','<p>The Old Fashioned is a cocktail made by muddling sugar with bitters, then adding alcohol, originally whiskey but now sometimes brandy, and finally a twist of citrus rind. It is traditionally served in a short, round, tumbler-like glass, which is called an Old Fashioned glass, named after the drink.</p>\n<p>The Old Fashioned, developed during the 19th century and given its name in the 1880s, is an IBA Official Cocktail. It is also one of six basic drinks listed in David A. Embury\'s The Fine Art of Mixing Drinks.</p>','[{"col1":"Combine ingredients in a glass."},{"col1":"Douse with a few drops of water."},{"col1":"Add several large ice cubes and stir rapidly with a bar spoon to chill."},{"col1":"Garnish, if you like, with a slice of orange and/or a cherry."}]',NULL,'old-fashioned'),
	(39,79,1,'Sangria','2018-09-20 22:27:18','2018-09-23 23:16:19','fa42cf18-486e-4f2f-a6ab-72b601a0c685','<p>Sangria is an alcoholic beverage of Spanish origin. A punch, the sangria traditionally consists of red wine and chopped fruit, often with other ingredients such as orange juice or brandy.</p>','[{"col1":"In a large pitcher or bowl, mix together the brandy, lemon juice, lemonade concentrate, orange juice, red wine, triple sec, and sugar."},{"col1":"Float slices of lemon, orange and lime, and maraschino cherries in the mixture."},{"col1":"Refrigerate overnight for best flavor."},{"col1":"For a fizzy sangria, add club soda just before serving."}]',NULL,'pitcher'),
	(40,92,1,'Aperol Spritz','2018-09-20 22:30:34','2018-09-23 23:14:09','367fd8d0-7915-4461-9dc3-dabc79d7f20f','<p>An Aperol Spritz is an aperitif cocktail consisting of prosecco, Aperol and soda water.</p>','[{"col1":"Fill a white wine glass halfway with ice."},{"col1":"Add the Aperol, prosecco and sparkling water, and stir twice with a spoon."},{"col1":"Serve with an orange slice if desired."}]',NULL,'wine-grande'),
	(41,96,1,'Martini','2018-09-20 23:47:17','2018-09-20 23:53:57','a06d56c1-f782-4dc4-a2e8-538dca9429f9',NULL,NULL,NULL,NULL),
	(42,97,1,'Mojito','2018-09-20 23:47:20','2018-09-20 23:50:33','a4e0785f-0523-4676-9cd2-aabc8ad7272f',NULL,NULL,NULL,NULL),
	(43,98,1,'Mojito','2018-09-20 23:50:50','2018-09-23 23:13:14','c44bbc29-4495-4cf6-b328-2739a781101c','<p>Mojito is a traditional Cuban highball.</p>\n<p>Traditionally, a mojito is a cocktail that consists of five ingredients: white rum, sugar (traditionally sugar cane juice), lime juice, soda water, and mint. Its combination of sweetness, citrus, and mint flavors is intended to complement the rum, and has made the mojito a popular summer drink. The cocktail has a relatively low alcohol content (about 10% alcohol by volume).</p>\n<p>When preparing a mojito, fresh lime juice is added to sugar (or to simple syrup) and mint leaves. The mixture is then gently mashed with a muddler. The mint leaves should only be bruised to release the essential oils and should not be shredded. Then rum is added and the mixture is briefly stirred to dissolve the sugar and to lift the mint leaves up from the bottom for better presentation. Finally, the drink is topped with crushed ice and sparkling soda water. Mint leaves and lime wedges are used to garnish the glass.</p>','[{"col1":"Place mint leaves and 1 lime wedge into a sturdy glass."},{"col1":"Use a muddler to crush the mint and lime to release the mint oils and lime juice."},{"col1":"Add 2 more lime wedges and the sugar, and muddle again to release the lime juice."},{"col1":"Do not strain the mixture. Fill the glass almost to the top with ice."},{"col1":"Pour the rum over the ice, and fill the glass with carbonated water."},{"col1":"Stir, taste, and add more sugar if desired."},{"col1":"Garnish with the remaining lime wedge."}]',NULL,'highball'),
	(44,105,1,'Gin Martini','2018-09-20 23:53:08','2018-09-24 00:17:33','f18a758c-2ad0-4af5-833a-3b9a03d68c79','<p>H. L. Mencken called the martini "the only American invention as perfect as the sonnet" and E. B. White called it "the elixir of quietude".</p>','[{"col1":"Pour ice, gin and vermouth into a glass shaker."},{"col1":"Shake and pour into a martini glass."},{"col1":"Garnish with olives or lemon twist."}]',NULL,'martini'),
	(51,162,1,NULL,'2018-09-22 03:40:35','2018-09-24 00:16:17','8db6776d-b7b8-48c8-8c28-7dc97914a519',NULL,NULL,'Bend, OR',NULL),
	(52,163,1,'Bjorn','2018-09-22 03:40:39','2018-09-22 03:40:39','d9a0825a-c7a7-433c-8733-d09592b561dc',NULL,NULL,NULL,NULL),
	(53,164,1,NULL,'2018-09-22 03:41:04','2018-09-22 03:44:52','b3d2df71-e4d2-43c9-9733-532e7de137ca',NULL,NULL,'Bend, OR',NULL),
	(54,165,1,'Cathie','2018-09-22 03:41:10','2018-09-22 03:41:10','158f705e-470a-4294-ab77-73389c1d6c21',NULL,NULL,NULL,NULL),
	(55,166,1,NULL,'2018-09-22 03:41:34','2018-09-22 03:41:51','7e4a29c8-2a43-4d5d-bb2e-f8613a951042',NULL,NULL,'Bend, OR',NULL),
	(56,167,1,'Dale','2018-09-22 03:41:49','2018-09-22 03:41:49','ba0a63e6-51b6-4da6-a5ce-5e0c1b407b68',NULL,NULL,NULL,NULL),
	(57,168,1,NULL,'2018-09-22 03:42:35','2018-09-22 03:44:56','d1493ce5-11b7-46c0-a8a9-1a229323ab67',NULL,NULL,'Bend, OR',NULL),
	(58,169,1,'Dale 180922 034251','2018-09-22 03:42:51','2018-09-22 03:42:55','31067f07-cd76-4ebd-9b71-127888813263',NULL,NULL,NULL,NULL),
	(59,170,1,NULL,'2018-09-22 03:43:35','2018-09-22 03:56:18','b8268807-0081-4deb-ad9d-95d464f58b8a',NULL,NULL,'Bend, OR',NULL),
	(60,171,1,'Tiff','2018-09-22 03:43:44','2018-09-22 03:43:44','50bfb2ea-6c6a-40f6-81fa-1a8773cff171',NULL,NULL,NULL,NULL),
	(61,172,1,NULL,'2018-09-22 03:44:13','2018-09-22 03:45:06','f4aa2407-71ab-43bf-bcd5-91f405c4e9a6',NULL,NULL,'Bend, OR',NULL),
	(62,173,1,'Tj','2018-09-22 03:44:20','2018-09-22 03:44:20','4bf67011-c8b0-4f7f-a6e2-609f87ffe7e0',NULL,NULL,NULL,NULL),
	(63,174,1,'Vermouth','2018-09-23 23:10:06','2018-09-23 23:11:23','c9f52d34-0531-4cb1-9bac-89db10ede3ad',NULL,NULL,NULL,NULL),
	(64,175,1,'White Rum','2018-09-23 23:12:45','2018-09-23 23:12:45','dadf590d-29e3-4e9d-ac24-2a2fd8a10060',NULL,NULL,NULL,NULL),
	(65,176,1,'Club Soda','2018-09-23 23:12:58','2018-09-23 23:12:58','0aded724-72a2-4269-a6a9-7aba9a8394f3',NULL,NULL,NULL,NULL),
	(66,177,1,'Aperol','2018-09-23 23:13:35','2018-09-23 23:13:35','36432a85-af12-4f94-86a8-5e1f2b8e84d3',NULL,NULL,NULL,NULL),
	(67,178,1,'Prosecco','2018-09-23 23:13:53','2018-09-23 23:13:53','6760ee76-541f-47fc-bc6b-2a68dfec1531',NULL,NULL,NULL,NULL),
	(68,179,1,'Brandy','2018-09-23 23:14:19','2018-09-23 23:14:19','e70ae14b-4d4c-4c1e-9a86-ed0fae250333',NULL,NULL,NULL,NULL),
	(69,180,1,'Orange Juice','2018-09-23 23:14:45','2018-09-23 23:14:45','69b94146-0439-4526-bc2f-524714cc1c9d',NULL,NULL,NULL,NULL),
	(70,181,1,'Red Wine','2018-09-23 23:14:58','2018-09-23 23:14:58','4e763e6f-da3c-43b5-9f4a-eea7c43f0aa4',NULL,NULL,NULL,NULL),
	(71,182,1,'Triple Sec','2018-09-23 23:15:35','2018-09-23 23:15:35','f838c80c-f5f5-4812-8d75-e957e35b1ebd',NULL,NULL,NULL,NULL),
	(72,183,1,'Simple Syrup','2018-09-23 23:16:32','2018-09-23 23:16:32','8f1cc887-ff53-417d-b837-f2d70ab98fd3',NULL,NULL,NULL,NULL),
	(73,184,1,'Bitters','2018-09-23 23:16:43','2018-09-23 23:16:43','f75e5dde-1525-4dba-a498-119ceacf42eb',NULL,NULL,NULL,NULL),
	(74,185,1,'Champagne','2018-09-23 23:16:59','2018-09-23 23:16:59','9de65b50-2630-495d-982e-09ad837c58a9',NULL,NULL,NULL,NULL),
	(75,186,1,'Tequila','2018-09-23 23:17:31','2018-09-23 23:17:31','3844aac7-bcb5-429a-8186-a4e875fbacfa',NULL,NULL,NULL,NULL),
	(76,187,1,'Whiskey','2018-09-23 23:18:37','2018-09-23 23:18:37','2b21cc56-9d8c-4070-b724-e8b6ad16ec46',NULL,NULL,NULL,NULL),
	(79,190,1,NULL,'2018-09-24 00:15:03','2018-09-24 00:15:11','8d9950e8-b5b1-46f9-ac2b-e126a99541ea',NULL,NULL,'Bend, OR',NULL),
	(80,191,1,'Veronica','2018-09-24 00:15:08','2018-09-24 00:15:08','ace36b9d-9209-44dd-a8a7-be82b5ed6aea',NULL,NULL,NULL,NULL);
ALTER TABLE `content` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `craftidtokens` WRITE;
ALTER TABLE `craftidtokens` DISABLE KEYS;
ALTER TABLE `craftidtokens` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `deprecationerrors` WRITE;
ALTER TABLE `deprecationerrors` DISABLE KEYS;
ALTER TABLE `deprecationerrors` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `elementindexsettings` WRITE;
ALTER TABLE `elementindexsettings` DISABLE KEYS;
INSERT INTO `elementindexsettings` (`id`, `type`, `settings`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'craft\\elements\\User','{"sources":{"*":{"tableAttributes":{"1":"field:7","2":"email","3":"dateCreated"}}}}','2018-09-24 00:08:04','2018-09-24 00:08:04','cec86ea2-35dc-4076-8d6b-b8044582ebe8'),
	(3,'craft\\elements\\Entry','{"sources":{"section:1":{"tableAttributes":[]},"section:2":{"tableAttributes":{"1":"field:1","2":"author","3":"link"}}}}','2018-09-24 00:06:05','2018-09-24 00:06:05','cc757772-2c77-49b8-aea5-29e9aad529fa');
ALTER TABLE `elementindexsettings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `elements_sites` WRITE;
ALTER TABLE `elements_sites` DISABLE KEYS;
INSERT INTO `elements_sites` (`id`, `elementId`, `siteId`, `slug`, `uri`, `enabled`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,1,1,NULL,NULL,1,'2018-09-18 20:53:52','2018-09-24 00:18:39','00db31f0-4ba8-4fc0-a425-8ab93fe4ac76'),
	(4,4,1,'gin',NULL,1,'2018-09-19 10:28:34','2018-09-23 23:11:23','d946611d-d711-4dcb-9ebf-3c96fd906b68'),
	(6,6,1,'vodka',NULL,1,'2018-09-19 10:30:01','2018-09-23 23:11:23','c51bf136-19d5-4fae-b0a8-047eabb74ca5'),
	(8,8,1,'tonic-water',NULL,1,'2018-09-19 10:32:53','2018-09-23 23:11:23','b46a543a-c410-4f94-a0cf-217bf79c551a'),
	(9,9,1,'gin-and-tonic','recipes/gin-and-tonic',1,'2018-09-19 10:35:43','2018-09-24 00:17:23','979a8c98-3098-400f-9177-6815998316d6'),
	(12,12,1,NULL,NULL,1,'2018-09-19 10:37:23','2018-09-20 21:12:14','bc9112be-1046-420e-a95d-38bcb16dac08'),
	(13,13,1,'vodka-tonic','recipes/vodka-tonic',1,'2018-09-19 10:37:38','2018-09-22 03:55:31','63d058be-6641-459f-a168-cb70f1c01d54'),
	(16,16,1,NULL,NULL,1,'2018-09-19 10:38:42','2018-09-20 21:12:02','2bf7d190-9005-4d37-8209-60f3c852723f'),
	(17,17,1,'salty-dog','recipes/salty-dog',1,'2018-09-20 05:47:11','2018-09-22 03:53:49','87b64517-de34-49eb-b8ff-8215b77d7fec'),
	(18,18,1,NULL,NULL,1,'2018-09-20 09:20:19','2018-09-20 21:11:37','48b144f5-778d-4414-9900-eda5109429b8'),
	(19,19,1,'grapefruit-juice',NULL,1,'2018-09-20 09:20:55','2018-09-23 23:11:23','d3bef49d-1598-4aaa-941e-95f45b81c5d3'),
	(25,25,1,NULL,NULL,1,'2018-09-20 21:15:56','2018-09-20 21:21:46','5d661f61-6bbd-46bd-af69-eb99beff64b8'),
	(26,26,1,NULL,NULL,1,'2018-09-20 21:16:01','2018-09-20 21:46:41','d99bf797-019f-486c-babe-2a16c0b60624'),
	(27,27,1,NULL,NULL,1,'2018-09-20 21:16:06','2018-09-20 21:55:06','98952f9c-00af-4c20-b697-0e72b84f8865'),
	(28,28,1,NULL,NULL,1,'2018-09-20 21:16:12','2018-09-20 22:05:04','1320a240-bb1c-4322-a644-972a06ec1381'),
	(29,29,1,NULL,NULL,1,'2018-09-20 21:16:16','2018-09-20 22:05:50','2af1639c-f941-43c9-aa77-b24e8d9f00c2'),
	(30,30,1,NULL,NULL,1,'2018-09-20 21:16:19','2018-09-20 22:14:22','ec30aa02-38d8-4e15-b430-27805b7a0bbd'),
	(31,31,1,NULL,NULL,1,'2018-09-20 21:16:23','2018-09-20 22:16:03','622377ce-0280-4884-bcfd-5c453dac806a'),
	(32,32,1,NULL,NULL,1,'2018-09-20 21:16:27','2018-09-20 22:19:30','e4a8adc6-b0ec-41d0-989f-710216b1803e'),
	(33,33,1,NULL,NULL,1,'2018-09-20 21:16:34','2018-09-20 22:24:54','6e67ec11-a618-4a87-848c-1afbca9d2d6e'),
	(34,34,1,NULL,NULL,1,'2018-09-20 21:16:37','2018-09-20 22:28:19','6e92a860-bcc0-441f-be12-427a3d5e0ccd'),
	(37,37,1,'apple-cider','recipes/apple-cider',1,'2018-09-20 21:24:15','2018-09-22 03:52:56','8d67da35-ad4d-4051-8ae5-854d3382f4cd'),
	(40,40,1,NULL,NULL,1,'2018-09-20 21:29:33','2018-09-22 03:52:56','1411621b-aa6e-4b4b-aa1a-9f5cb0aa7912'),
	(41,41,1,NULL,NULL,1,'2018-09-20 21:29:33','2018-09-22 03:52:56','f9607079-4c2b-4857-a192-36e59f0ead0e'),
	(42,42,1,NULL,NULL,1,'2018-09-20 21:30:01','2018-09-22 03:53:49','3e968d02-6e0b-432e-801e-9e74aec8ecd6'),
	(43,43,1,NULL,NULL,1,'2018-09-20 21:30:01','2018-09-22 03:53:49','5f45106f-520f-4412-bdaf-7104154bb936'),
	(44,44,1,NULL,NULL,1,'2018-09-20 21:30:25','2018-09-22 03:55:32','d78d1079-c3c8-4724-80b7-9387a0a32597'),
	(45,45,1,NULL,NULL,1,'2018-09-20 21:30:25','2018-09-22 03:55:32','c3b0f5a8-1321-4ba2-96fc-76e32fe443e6'),
	(46,46,1,NULL,NULL,1,'2018-09-20 21:30:58','2018-09-24 00:17:23','f9ba71bc-dc55-4f37-8a1b-fc6b6cf8cdce'),
	(47,47,1,NULL,NULL,1,'2018-09-20 21:30:58','2018-09-24 00:17:23','78c1a4d0-315e-4dd0-af77-77cc32226105'),
	(48,48,1,'arnold-palmer','recipes/arnold-palmer',1,'2018-09-20 21:50:46','2018-09-22 03:52:35','acae9aa4-2aaa-48f7-980f-ff52816fe118'),
	(49,49,1,NULL,NULL,1,'2018-09-20 21:50:46','2018-09-22 03:52:35','0c617560-d7e0-4e52-bce4-ddc04b47dccc'),
	(50,50,1,NULL,NULL,1,'2018-09-20 21:50:46','2018-09-22 03:52:35','4191bf78-0d28-4b4c-8ed6-62dda806bc5d'),
	(51,51,1,'irish-coffee','recipes/irish-coffee',1,'2018-09-20 21:59:33','2018-09-23 23:18:55','7a866335-5952-415d-a110-506031ae28a0'),
	(52,52,1,NULL,NULL,1,'2018-09-20 21:59:34','2018-09-23 23:18:55','3eb578d6-9acf-4173-9a95-7d3c99bf40d7'),
	(53,53,1,NULL,NULL,1,'2018-09-20 21:59:34','2018-09-23 23:18:55','07aabc43-63b3-4a26-bf7a-991f7cc1042e'),
	(54,54,1,NULL,NULL,1,'2018-09-20 21:59:34','2018-09-23 23:18:55','0fc59438-3f72-4d0f-8b4e-e504eea3126a'),
	(55,55,1,'lemonade','recipes/lemonade',1,'2018-09-20 22:05:14','2018-09-22 03:58:27','69bbf0e9-0cda-4531-ad6f-cf5952338771'),
	(56,56,1,NULL,NULL,1,'2018-09-20 22:05:14','2018-09-22 03:58:27','474fb969-e7ad-4760-a536-4377d36b3ad2'),
	(57,57,1,NULL,NULL,1,'2018-09-20 22:05:14','2018-09-22 03:58:27','31988f9e-0bb9-48cf-96b1-f43be533fa23'),
	(58,58,1,'lemondrop','recipes/lemondrop',1,'2018-09-20 22:09:38','2018-09-22 03:50:49','b98466eb-a408-42b1-9508-69d284870793'),
	(59,59,1,NULL,NULL,1,'2018-09-20 22:09:38','2018-09-22 03:50:49','747370a2-8088-449f-8ec6-aa212a29164a'),
	(60,60,1,NULL,NULL,1,'2018-09-20 22:09:39','2018-09-22 03:50:49','a471235f-2878-47b9-b94e-41408efc7f99'),
	(61,61,1,NULL,NULL,1,'2018-09-20 22:09:39','2018-09-22 03:50:49','856d5d2c-92b1-49fe-8858-3091ea88c81c'),
	(62,62,1,NULL,NULL,1,'2018-09-20 22:09:39','2018-09-22 03:50:49','41f7f7c0-cb60-4a8c-bd56-959020c7ed67'),
	(63,63,1,NULL,NULL,1,'2018-09-20 22:09:39','2018-09-22 03:50:49','d0269421-8f26-4f11-bb45-41702537b0d0'),
	(64,64,1,'margarita','recipes/margarita',1,'2018-09-20 22:14:46','2018-09-23 23:18:13','bc1896a0-ca99-44e2-bfe8-bebd7531b4c2'),
	(65,65,1,NULL,NULL,1,'2018-09-20 22:14:46','2018-09-23 23:18:13','805db215-806e-4d45-a2c4-e3d0907c7390'),
	(66,66,1,NULL,NULL,1,'2018-09-20 22:14:46','2018-09-23 23:18:13','1c5a607d-1391-438f-a5bc-8fb3e888e7a9'),
	(67,67,1,NULL,NULL,1,'2018-09-20 22:14:46','2018-09-23 23:18:13','76609c60-5335-44d2-b545-e62e619e9e4c'),
	(68,68,1,NULL,NULL,1,'2018-09-20 22:14:46','2018-09-23 23:18:13','1e0bec2f-7f00-4aca-980c-69e7f611b290'),
	(69,69,1,NULL,NULL,1,'2018-09-20 22:14:46','2018-09-23 23:18:13','1669dfca-d921-459e-ae60-d538a80e203b'),
	(70,70,1,NULL,NULL,1,'2018-09-20 22:14:46','2018-09-23 23:18:13','55f5a423-75c6-4b86-8d9a-0b64385895de'),
	(71,71,1,'mimosa','recipes/mimosa',1,'2018-09-20 22:18:27','2018-09-23 23:17:09','44097e86-f09a-4a69-bce3-8bf1c8b5818d'),
	(72,72,1,NULL,NULL,1,'2018-09-20 22:18:27','2018-09-23 23:17:09','278bd3f7-7099-4909-b7aa-4bbae92013c5'),
	(73,73,1,NULL,NULL,1,'2018-09-20 22:18:27','2018-09-23 23:17:09','d71f3ab3-f246-4d99-95c0-b162529c5a67'),
	(74,74,1,'old-fashioned','recipes/old-fashioned',1,'2018-09-20 22:22:34','2018-09-24 00:17:40','514d47ca-f841-4fae-8da2-380e1fe5472f'),
	(75,75,1,NULL,NULL,1,'2018-09-20 22:22:34','2018-09-24 00:17:40','616536c3-ad7a-4e32-9660-24dc64ab34fc'),
	(76,76,1,NULL,NULL,1,'2018-09-20 22:22:34','2018-09-24 00:17:40','f5573fd8-13f4-44ef-a33d-1b66e0e247cb'),
	(77,77,1,NULL,NULL,1,'2018-09-20 22:22:34','2018-09-24 00:17:40','734b6a05-c5c2-4f0f-bdc6-59654803116f'),
	(79,79,1,'sangria','recipes/sangria',1,'2018-09-20 22:27:18','2018-09-23 23:16:19','5c3e2ec2-c199-41d3-9fb9-60712913f68a'),
	(80,80,1,NULL,NULL,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','c5f7662c-2133-4399-91e8-6ed20e4b83c3'),
	(81,81,1,NULL,NULL,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','789a047b-0c2c-4ec6-8ed1-284fa0efa753'),
	(82,82,1,NULL,NULL,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','c70ac7b5-2460-45d0-8626-f7f2d8911865'),
	(83,83,1,NULL,NULL,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','a99afeb6-22d0-46ba-b4b2-4b89ffd4e722'),
	(84,84,1,NULL,NULL,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','bd546c51-89c4-4f70-946a-c50c024ec397'),
	(85,85,1,NULL,NULL,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','1501cefa-bfb4-4494-8f07-6f043d8c7854'),
	(86,86,1,NULL,NULL,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','6a5252fd-d5c2-4a55-b2d0-076d08599e96'),
	(87,87,1,NULL,NULL,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','c24f1c44-b381-453e-85f9-9e2e524b0dec'),
	(88,88,1,NULL,NULL,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','c066bfae-644c-42f6-afdd-89bb26c04201'),
	(89,89,1,NULL,NULL,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','b994cc7e-5d46-4445-93e1-fd6bc229bffd'),
	(90,90,1,NULL,NULL,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','8db69825-fbe0-4d09-84cf-fe84d170faa8'),
	(91,91,1,NULL,NULL,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','04cf6e53-30fe-4cd9-86a6-25481c293e11'),
	(92,92,1,'aperol-spritz','recipes/aperol-spritz',1,'2018-09-20 22:30:34','2018-09-23 23:14:09','00d9c00d-c92f-44fd-8b3c-61690ad01ee6'),
	(93,93,1,NULL,NULL,1,'2018-09-20 22:30:35','2018-09-23 23:14:09','642ba1c9-eda4-4f78-9648-c63994a75370'),
	(94,94,1,NULL,NULL,1,'2018-09-20 22:30:35','2018-09-23 23:14:09','dcf4cc3a-e751-41b8-bf32-62ca665346c3'),
	(95,95,1,NULL,NULL,1,'2018-09-20 22:30:35','2018-09-23 23:14:09','251fe852-a01b-46d5-a3cd-b0352028b7da'),
	(96,96,1,NULL,NULL,1,'2018-09-20 23:47:17','2018-09-20 23:53:57','e8ff521f-2a7a-4200-876b-c857e1feed8f'),
	(97,97,1,NULL,NULL,1,'2018-09-20 23:47:20','2018-09-20 23:50:33','7312c99f-eb8e-4b3d-b297-64eb72a42f33'),
	(98,98,1,'mojito','recipes/mojito',1,'2018-09-20 23:50:50','2018-09-23 23:13:14','489e47c5-229a-429f-be88-623c6bf76e6c'),
	(99,99,1,NULL,NULL,1,'2018-09-20 23:50:50','2018-09-23 23:13:14','3eba559c-9f05-4c10-a330-32c3d4141e6a'),
	(100,100,1,NULL,NULL,1,'2018-09-20 23:50:50','2018-09-23 23:13:14','070b12ed-ab1b-43a2-8e4a-26f47ee665c6'),
	(101,101,1,NULL,NULL,1,'2018-09-20 23:50:50','2018-09-23 23:13:14','84885e0d-60c8-4b0e-a27f-0704359165ba'),
	(102,102,1,NULL,NULL,1,'2018-09-20 23:50:50','2018-09-23 23:13:14','53861d60-cd46-4c39-a100-5ecf7a4ec5cd'),
	(103,103,1,NULL,NULL,1,'2018-09-20 23:50:50','2018-09-23 23:13:14','44641aba-5311-4eb5-9cf3-34d26105b547'),
	(104,104,1,NULL,NULL,1,'2018-09-20 23:50:50','2018-09-23 23:13:14','8b6fb88a-3d02-4847-abff-1c896f97a137'),
	(105,105,1,'martini','recipes/martini',1,'2018-09-20 23:53:08','2018-09-24 00:17:33','f9f598cc-67b7-41bb-ad35-9071651dd3a0'),
	(155,155,1,NULL,NULL,1,'2018-09-21 17:07:51','2018-09-24 00:17:33','74390f1f-f66d-4080-9327-6dd2aeb9ca42'),
	(156,156,1,NULL,NULL,1,'2018-09-21 17:07:51','2018-09-24 00:17:33','13e6d75d-d4a2-4720-b30c-c98841f37dd4'),
	(157,157,1,NULL,NULL,1,'2018-09-21 17:07:51','2018-09-24 00:17:33','c90621ef-264e-42ae-878b-a3510f05a470'),
	(162,162,1,NULL,NULL,1,'2018-09-22 03:40:35','2018-09-24 00:16:17','d9c3bd24-c541-437e-bd77-34dadd5df184'),
	(163,163,1,NULL,NULL,1,'2018-09-22 03:40:39','2018-09-22 03:40:39','87418f21-fab8-4984-ae24-33a53c938bac'),
	(164,164,1,NULL,NULL,1,'2018-09-22 03:41:04','2018-09-22 03:44:52','022a576d-9360-4db1-aae8-c865eea1c292'),
	(165,165,1,NULL,NULL,1,'2018-09-22 03:41:10','2018-09-22 03:41:10','e3700320-8ea1-43e5-8fff-b7518a520cb7'),
	(166,166,1,NULL,NULL,1,'2018-09-22 03:41:34','2018-09-22 03:41:51','e7260282-7cbd-4205-95be-67885970df52'),
	(167,167,1,NULL,NULL,1,'2018-09-22 03:41:49','2018-09-22 03:41:49','2ac0891e-7b14-4e8f-9063-6710bc51e213'),
	(168,168,1,NULL,NULL,1,'2018-09-22 03:42:35','2018-09-22 03:44:56','57df275c-74a6-4914-8ca4-9b37d68f2b00'),
	(169,169,1,NULL,NULL,1,'2018-09-22 03:42:51','2018-09-22 03:42:55','2eeb01e3-904b-47e3-b114-43ddb23e3825'),
	(170,170,1,NULL,NULL,1,'2018-09-22 03:43:35','2018-09-22 03:56:18','436ef0e3-6fa1-4a08-b4b8-e1fa176c6452'),
	(171,171,1,NULL,NULL,1,'2018-09-22 03:43:44','2018-09-22 03:43:44','d6a4510a-c473-469b-a339-180d2d196d8e'),
	(172,172,1,NULL,NULL,1,'2018-09-22 03:44:13','2018-09-22 03:45:06','b3431432-bf5e-4dc3-a1b9-ce4d034a6c05'),
	(173,173,1,NULL,NULL,1,'2018-09-22 03:44:20','2018-09-22 03:44:20','1dfdf04f-f974-4194-98aa-ac50d2e65b9c'),
	(174,174,1,'vermouth',NULL,1,'2018-09-23 23:10:06','2018-09-23 23:11:23','602d9fe1-29a9-4203-a466-5cb8f76ab09c'),
	(175,175,1,'white-rum',NULL,1,'2018-09-23 23:12:45','2018-09-23 23:12:45','2ac9d419-7a1d-4da0-933f-183724760c4b'),
	(176,176,1,'club-soda',NULL,1,'2018-09-23 23:12:58','2018-09-23 23:12:58','577f3fd0-368e-4eda-a6f7-85cb164deed2'),
	(177,177,1,'aperol',NULL,1,'2018-09-23 23:13:35','2018-09-23 23:13:35','1145c5ef-0c85-470d-8614-d707b18cb6c5'),
	(178,178,1,'prosecco',NULL,1,'2018-09-23 23:13:53','2018-09-23 23:13:53','a1402531-1f9d-4860-96d8-df4f663b726a'),
	(179,179,1,'brandy',NULL,1,'2018-09-23 23:14:19','2018-09-23 23:14:19','cc597e8e-d8b5-4c0d-9a4b-2686d3dc699c'),
	(180,180,1,'orange-juice',NULL,1,'2018-09-23 23:14:45','2018-09-23 23:14:45','3545ef43-df5e-4981-8c24-1e0b8d33b3d5'),
	(181,181,1,'red-wine',NULL,1,'2018-09-23 23:14:58','2018-09-23 23:14:58','294c97dc-db16-40de-919c-faf1224827ec'),
	(182,182,1,'triple-sec',NULL,1,'2018-09-23 23:15:35','2018-09-23 23:15:35','282720d6-dafb-4128-a259-4389aaa02f5d'),
	(183,183,1,'simple-syrup',NULL,1,'2018-09-23 23:16:32','2018-09-23 23:16:32','7c637aa6-c471-4021-adb2-133384687387'),
	(184,184,1,'bitters',NULL,1,'2018-09-23 23:16:43','2018-09-23 23:16:43','f6783cc6-e23b-4104-b445-3d07a60a29cc'),
	(185,185,1,'champagne',NULL,1,'2018-09-23 23:16:59','2018-09-23 23:16:59','e396c074-0bbf-4f3e-a5b9-072293028266'),
	(186,186,1,'tequila',NULL,1,'2018-09-23 23:17:31','2018-09-23 23:17:31','501b6ab3-bcc5-45ac-81b0-33170169f30d'),
	(187,187,1,'whiskey',NULL,1,'2018-09-23 23:18:37','2018-09-23 23:18:37','d4673fd2-77ff-46ec-9110-eac6dc7a28ea'),
	(190,190,1,NULL,NULL,1,'2018-09-24 00:15:03','2018-09-24 00:15:11','ac07d9b0-c434-4326-9ad9-2b021afdbb60'),
	(191,191,1,NULL,NULL,1,'2018-09-24 00:15:08','2018-09-24 00:15:08','d30f098a-6c01-4f95-a665-81355909b64b');
ALTER TABLE `elements_sites` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `entries` WRITE;
ALTER TABLE `entries` DISABLE KEYS;
INSERT INTO `entries` (`id`, `sectionId`, `typeId`, `authorId`, `postDate`, `expiryDate`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(4,1,1,1,'2018-09-19 10:28:00',NULL,'2018-09-19 10:28:34','2018-09-23 23:11:23','7047f2e6-2188-4b43-91b7-8f5671f1ce0e'),
	(6,1,1,1,'2018-09-19 10:30:00',NULL,'2018-09-19 10:30:01','2018-09-23 23:11:23','465f1868-b988-4602-82b3-f62a890523b1'),
	(8,1,1,1,'2018-09-19 10:32:00',NULL,'2018-09-19 10:32:53','2018-09-23 23:11:23','a87487f3-12f8-48b5-9f05-9e3daa964f77'),
	(9,2,2,190,'2018-09-19 10:35:00',NULL,'2018-09-19 10:35:43','2018-09-24 00:17:23','fedb9540-036a-48ca-9eab-2755752eaa30'),
	(13,2,2,164,'2018-09-19 10:37:00',NULL,'2018-09-19 10:37:38','2018-09-22 03:55:31','80fd8175-68f7-40a7-b2ff-1d830bfc3481'),
	(17,2,2,166,'2018-09-20 05:47:00',NULL,'2018-09-20 05:47:11','2018-09-22 03:53:49','0eb79915-dba3-437d-939f-78d47e409604'),
	(19,1,1,1,'2018-09-20 09:20:00',NULL,'2018-09-20 09:20:55','2018-09-23 23:11:23','d0bd4723-1f23-47ed-92a4-53ea25c5ce24'),
	(37,2,2,170,'2018-09-20 21:24:00',NULL,'2018-09-20 21:24:15','2018-09-22 03:52:56','1a2cb5ad-c3dd-4ddb-99a1-a0f41b59701c'),
	(48,2,2,172,'2018-09-20 21:50:00',NULL,'2018-09-20 21:50:46','2018-09-22 03:52:35','bdbf97ec-c101-4c95-8326-db74cc158e82'),
	(51,2,2,166,'2018-09-20 21:59:00',NULL,'2018-09-20 21:59:34','2018-09-23 23:18:55','e8d10fbc-e217-49be-8d83-0c7a59fc0a4b'),
	(55,2,2,168,'2018-09-20 22:05:00',NULL,'2018-09-20 22:05:14','2018-09-22 03:58:27','01a23144-a1bc-428a-ae75-71dd34a0d2cf'),
	(58,2,2,170,'2018-09-20 22:09:00',NULL,'2018-09-20 22:09:38','2018-09-22 03:50:49','5657f295-50ff-4d3c-ac39-482b1153f971'),
	(64,2,2,168,'2018-09-20 22:14:00',NULL,'2018-09-20 22:14:46','2018-09-23 23:18:13','ede7bc54-0a6c-4be3-b279-8b3bc8eef8c9'),
	(71,2,2,164,'2018-09-20 22:18:00',NULL,'2018-09-20 22:18:27','2018-09-23 23:17:09','21c1f3df-e060-4d65-86e8-2560a79b473d'),
	(74,2,2,190,'2018-09-20 22:22:00',NULL,'2018-09-20 22:22:34','2018-09-24 00:17:40','3551fdaf-0c9a-4695-a2ac-3e9d6d3b9866'),
	(79,2,2,164,'2018-09-20 22:27:00',NULL,'2018-09-20 22:27:18','2018-09-23 23:16:19','df1a2962-844b-433e-99f1-df493da7a04d'),
	(92,2,2,172,'2018-09-20 22:30:00',NULL,'2018-09-20 22:30:35','2018-09-23 23:14:09','64333d6c-1a38-4566-930f-75525d96ffac'),
	(98,2,2,170,'2018-09-20 23:50:00',NULL,'2018-09-20 23:50:50','2018-09-23 23:13:14','8e1d84de-86a9-485a-b7a7-27ac16ca91d3'),
	(105,2,2,190,'2018-09-20 23:53:00',NULL,'2018-09-20 23:53:08','2018-09-24 00:17:33','42ace287-2657-4f14-b4b7-adad880040b2'),
	(174,1,1,1,'2018-09-23 23:10:00',NULL,'2018-09-23 23:10:06','2018-09-23 23:11:23','d446801f-aca3-4399-b0f8-871396a5781b'),
	(175,1,1,1,'2018-09-23 23:12:00',NULL,'2018-09-23 23:12:45','2018-09-23 23:12:45','21c7d6ee-85e3-4e71-89fb-967d37ac6fe3'),
	(176,1,1,1,'2018-09-23 23:12:00',NULL,'2018-09-23 23:12:58','2018-09-23 23:12:58','bd14fb18-484d-4dcd-b457-2a30e608c360'),
	(177,1,1,1,'2018-09-23 23:13:00',NULL,'2018-09-23 23:13:35','2018-09-23 23:13:35','af693d2e-e020-4639-bffd-ad985d1037ea'),
	(178,1,1,1,'2018-09-23 23:13:00',NULL,'2018-09-23 23:13:53','2018-09-23 23:13:53','089dfbfd-7a8e-4882-8358-1c37c70cb5da'),
	(179,1,1,1,'2018-09-23 23:14:00',NULL,'2018-09-23 23:14:19','2018-09-23 23:14:19','f65bd248-1607-4d6f-b710-dec1d1f525cb'),
	(180,1,1,1,'2018-09-23 23:14:00',NULL,'2018-09-23 23:14:45','2018-09-23 23:14:45','90381d32-0c28-4e79-ba4b-6af039930be9'),
	(181,1,1,1,'2018-09-23 23:14:00',NULL,'2018-09-23 23:14:58','2018-09-23 23:14:58','69af6ace-af93-45b6-9865-7f3cb1739fd7'),
	(182,1,1,1,'2018-09-23 23:15:00',NULL,'2018-09-23 23:15:35','2018-09-23 23:15:35','c80e0211-c280-4034-bb41-ab97401e6d98'),
	(183,1,1,1,'2018-09-23 23:16:00',NULL,'2018-09-23 23:16:32','2018-09-23 23:16:32','de84de84-51a2-48f4-91f4-1aee890577b0'),
	(184,1,1,1,'2018-09-23 23:16:00',NULL,'2018-09-23 23:16:43','2018-09-23 23:16:43','e793d580-7d73-4a91-b07e-d871b3c3225f'),
	(185,1,1,1,'2018-09-23 23:16:00',NULL,'2018-09-23 23:16:59','2018-09-23 23:16:59','bf4de6a8-b238-4b27-bacf-a22f4079ebc3'),
	(186,1,1,1,'2018-09-23 23:17:00',NULL,'2018-09-23 23:17:31','2018-09-23 23:17:31','2fa007a9-51b5-4872-9e85-bdba20949e7a'),
	(187,1,1,1,'2018-09-23 23:18:00',NULL,'2018-09-23 23:18:37','2018-09-23 23:18:37','58201b94-15b6-4406-8bc8-80370f0110b0');
ALTER TABLE `entries` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `entrydrafts` WRITE;
ALTER TABLE `entrydrafts` DISABLE KEYS;
ALTER TABLE `entrydrafts` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `fieldlayouts` WRITE;
ALTER TABLE `fieldlayouts` DISABLE KEYS;
INSERT INTO `fieldlayouts` (`id`, `type`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'craft\\elements\\Asset','2018-09-18 23:44:05','2018-09-18 23:44:05','7f61c56e-dddd-49b7-a697-3428565b696a'),
	(2,'craft\\elements\\Entry','2018-09-19 07:58:44','2018-09-23 23:11:23','6210b215-e598-4e1a-8816-867f8ab56760'),
	(3,'craft\\elements\\Asset','2018-09-19 08:00:14','2018-09-19 08:00:14','4ea67f34-e935-4025-8c05-99f5b5c5ce63'),
	(5,'craft\\elements\\Entry','2018-09-19 08:17:31','2018-09-20 21:43:49','4fdce50e-08be-42d5-8ef6-9a83fd7c66c2'),
	(6,'craft\\elements\\User','2018-09-19 09:29:20','2018-09-19 09:29:20','0944d11b-adcd-4f1e-a88a-e8f0c844a33e'),
	(7,'verbb\\supertable\\elements\\SuperTableBlockElement','2018-09-20 21:28:09','2018-09-20 21:28:09','5d5e747b-29c1-4189-aa98-a09644d5f98d');
ALTER TABLE `fieldlayouts` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `entrytypes` WRITE;
ALTER TABLE `entrytypes` DISABLE KEYS;
INSERT INTO `entrytypes` (`id`, `sectionId`, `fieldLayoutId`, `name`, `handle`, `hasTitleField`, `titleLabel`, `titleFormat`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,1,2,'Ingredient','ingredient',1,'Name',NULL,1,'2018-09-19 07:58:44','2018-09-23 23:11:23','ed546ec1-d1bf-4cf8-af00-6ab4805efe13'),
	(2,2,5,'Recipe','recipe',1,'Name',NULL,1,'2018-09-19 08:17:31','2018-09-20 21:43:49','996040aa-bf80-463b-85d8-99501e021189');
ALTER TABLE `entrytypes` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `entryversions` WRITE;
ALTER TABLE `entryversions` DISABLE KEYS;
ALTER TABLE `entryversions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `fieldgroups` WRITE;
ALTER TABLE `fieldgroups` DISABLE KEYS;
INSERT INTO `fieldgroups` (`id`, `name`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'Recipes','2018-09-18 20:53:52','2018-09-23 23:10:26','4465b71e-3d81-469d-972b-2994f6bad65f'),
	(2,'Members','2018-09-23 23:10:48','2018-09-23 23:10:48','bfea5c7f-318b-48f6-a589-7df32bc4d9fd');
ALTER TABLE `fieldgroups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `fieldlayouttabs` WRITE;
ALTER TABLE `fieldlayouttabs` DISABLE KEYS;
INSERT INTO `fieldlayouttabs` (`id`, `layoutId`, `name`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(5,6,'Profile',1,'2018-09-19 09:29:20','2018-09-19 09:29:20','3b486ab2-1e9e-4759-88c7-7dac2d3c0e54'),
	(10,7,'Content',1,'2018-09-20 21:28:09','2018-09-20 21:28:09','9ec904c0-f34f-410d-b3ef-d0e9cbb5362b'),
	(12,5,'Content',1,'2018-09-20 21:43:49','2018-09-20 21:43:49','691e8aee-9900-4701-8cab-723d2d22e9b6');
ALTER TABLE `fieldlayouttabs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `fields` WRITE;
ALTER TABLE `fields` DISABLE KEYS;
INSERT INTO `fields` (`id`, `groupId`, `name`, `handle`, `context`, `instructions`, `translationMethod`, `translationKeyFormat`, `type`, `settings`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,1,'Photo','photo','global','','site',NULL,'craft\\fields\\Assets','{"useSingleFolder":"","defaultUploadLocationSource":"folder:4","defaultUploadLocationSubpath":"","singleUploadLocationSource":"folder:1","singleUploadLocationSubpath":"","restrictFiles":"1","allowedKinds":["image"],"sources":["folder:4"],"source":null,"targetSiteId":null,"viewMode":"large","limit":"1","selectionLabel":"","localizeRelations":false}','2018-09-19 08:08:08','2018-09-19 08:08:08','e79df2bc-3632-451e-9087-7306b39c5c46'),
	(2,1,'Description','description','global','','none',NULL,'craft\\redactor\\Field','{"redactorConfig":"Simple.json","purifierConfig":"","cleanupHtml":"1","purifyHtml":"1","columnType":"text","availableVolumes":"*","availableTransforms":"*"}','2018-09-19 08:09:10','2018-09-19 08:09:10','978f6264-ce1d-481e-9c5f-e818203db47a'),
	(6,1,'Directions','directions','global','','none',NULL,'craft\\fields\\Table','{"addRowLabel":"Add a step","maxRows":"","minRows":"1","columns":{"col1":{"heading":"Step","handle":"step","width":"","type":"singleline"}},"defaults":{"row1":{"col1":""}},"columnType":"text"}','2018-09-19 08:17:11','2018-09-19 08:17:11','961b1f23-5905-4a96-af25-84f177c17509'),
	(7,2,'Location','location','global','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","code":"","multiline":"","initialRows":"4","charLimit":"","columnType":"string"}','2018-09-19 09:29:04','2018-09-23 23:10:58','e08613d3-4c6d-484a-840f-97089102bd3f'),
	(8,1,'Type of Glass','glass','global','','none',NULL,'craft\\fields\\Dropdown','{"options":[{"label":"Banquet Goblet","value":"goblet-banquet","default":""},{"label":"Beverage Glass","value":"beverage","default":""},{"label":"Brandy Snifter","value":"brandy-snifter","default":""},{"label":"Cooler Glass","value":"cooler","default":""},{"label":"Cordial Glass","value":"cordial","default":""},{"label":"Cordial Glass (Footed)","value":"cordial-footed","default":""},{"label":"Cosmo Martini Glass","value":"cosmo","default":""},{"label":"Flute","value":"flute","default":""},{"label":"Highball Glass","value":"highball","default":"1"},{"label":"Highball Glass (Footed)","value":"highball-footed","default":""},{"label":"Hurricane Glass","value":"hurricane","default":""},{"label":"Iced Tea Glass","value":"iced-tea","default":""},{"label":"Iced Tea Glass (Footed)","value":"iced-tea-footed","default":""},{"label":"Irish Coffee Glass","value":"irish-coffee","default":""},{"label":"Margarita Sauser","value":"margarita-sauser","default":""},{"label":"Margarita Glass","value":"margarita-welled","default":""},{"label":"Martini Glass","value":"martini","default":""},{"label":"Mug","value":"mug","default":""},{"label":"Old Fashioned Glass","value":"old-fashioned","default":""},{"label":"Pilsner Glass","value":"pilsner","default":""},{"label":"Pilsner Glass (Footed)","value":"pilsner-footed","default":""},{"label":"Pint Glass","value":"pint","default":""},{"label":"Pitcher","value":"pitcher","default":""},{"label":"Poco Grande Glass","value":"poco-grande","default":""},{"label":"Rocks Glass","value":"rocks","default":""},{"label":"Rocks Glass (Double)","value":"rocks-double","default":""},{"label":"Rocks Glass (Footed)","value":"rocks-footed","default":""},{"label":"Schooner","value":"schooner","default":""},{"label":"Seidel","value":"seidel","default":""},{"label":"Sherry Glass","value":"sherry","default":""},{"label":"Shooter Glass","value":"shooter","default":""},{"label":"Shooter Glass (Double)","value":"shooter-double","default":""},{"label":"Shot Glass (Marked)","value":"shot-marked","default":""},{"label":"Shot Glass","value":"shot","default":""},{"label":"Weizen Glass","value":"weizen","default":""},{"label":"Wine Glass (Grande)","value":"wine-grande","default":""},{"label":"Wine Glass (Red)","value":"wine-red","default":""},{"label":"Wine Glass (White)","value":"wine-white","default":""},{"label":"Zombie Glass","value":"zombie","default":""}]}','2018-09-20 06:30:50','2018-09-21 14:13:39','b4cc83de-f5aa-4aaf-a330-1988180b4366'),
	(9,1,'Ingredients','ingredients','global','','site',NULL,'verbb\\supertable\\fields\\SuperTableField','{"minRows":"1","maxRows":"","localizeBlocks":false,"staticField":"","columns":[],"fieldLayout":"table","selectionLabel":"Add an ingredient"}','2018-09-20 21:28:09','2018-09-20 21:28:09','59c12300-318b-47bc-b18b-c37d9728e8ba'),
	(10,NULL,'Label','label','superTableBlockType:1','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","code":"","multiline":"","initialRows":"4","charLimit":"","columnType":"string"}','2018-09-20 21:28:09','2018-09-20 21:28:09','25d55ce2-4a43-403a-9b02-2e5b61242f84'),
	(11,NULL,'Ingredient Entry','entry','superTableBlockType:1','','site',NULL,'craft\\fields\\Entries','{"sources":["section:1"],"source":null,"targetSiteId":null,"viewMode":null,"limit":"1","selectionLabel":"Select an entry","localizeRelations":false}','2018-09-20 21:28:09','2018-09-20 21:28:09','e68cbb26-302d-4787-bbe6-34d7b28896a8');
ALTER TABLE `fields` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `fieldlayoutfields` WRITE;
ALTER TABLE `fieldlayoutfields` DISABLE KEYS;
INSERT INTO `fieldlayoutfields` (`id`, `layoutId`, `tabId`, `fieldId`, `required`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(13,6,5,7,0,1,'2018-09-19 09:29:20','2018-09-19 09:29:20','fa50c507-28b1-4e16-93b8-667f1840e452'),
	(28,7,10,10,0,1,'2018-09-20 21:28:09','2018-09-20 21:28:09','201447e2-492e-4616-ac68-459401a36f06'),
	(29,7,10,11,0,2,'2018-09-20 21:28:09','2018-09-20 21:28:09','8e955d68-f3c4-4928-a49e-77d6401d91fb'),
	(36,5,12,1,0,1,'2018-09-20 21:43:49','2018-09-20 21:43:49','fe6a6cb3-a3b2-40c8-b2e3-d5482e625193'),
	(37,5,12,9,1,2,'2018-09-20 21:43:49','2018-09-20 21:43:49','e9ab5ebe-d722-435f-8270-18f14c358579'),
	(38,5,12,6,1,3,'2018-09-20 21:43:49','2018-09-20 21:43:49','3a33d899-298a-4bd6-918b-d348e53b5c71'),
	(39,5,12,2,0,4,'2018-09-20 21:43:49','2018-09-20 21:43:49','5b538162-6843-497c-957e-f4ba6bbd38c3'),
	(40,5,12,8,1,5,'2018-09-20 21:43:49','2018-09-20 21:43:49','df1d4e7b-9af6-4911-9128-d600135e495e');
ALTER TABLE `fieldlayoutfields` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `globalsets` WRITE;
ALTER TABLE `globalsets` DISABLE KEYS;
ALTER TABLE `globalsets` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `info` WRITE;
ALTER TABLE `info` DISABLE KEYS;
INSERT INTO `info` (`id`, `version`, `schemaVersion`, `edition`, `timezone`, `name`, `on`, `maintenance`, `fieldVersion`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'3.0.25','3.0.93',1,'America/Los_Angeles','On the Rocks',1,0,'9uYTwvxMaakO','2018-09-18 20:53:52','2018-09-23 23:10:58','81a38775-0c66-407f-a545-e9ff104a781f');
ALTER TABLE `info` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `matrixblocktypes` WRITE;
ALTER TABLE `matrixblocktypes` DISABLE KEYS;
ALTER TABLE `matrixblocktypes` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `matrixblocks` WRITE;
ALTER TABLE `matrixblocks` DISABLE KEYS;
ALTER TABLE `matrixblocks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `plugins` WRITE;
ALTER TABLE `plugins` DISABLE KEYS;
INSERT INTO `plugins` (`id`, `handle`, `version`, `schemaVersion`, `licenseKey`, `licenseKeyStatus`, `enabled`, `settings`, `installDate`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'redactor','2.1.6','2.0.0',NULL,'unknown',1,NULL,'2018-09-19 08:08:43','2018-09-19 08:08:43','2018-09-23 23:06:01','79de366d-bcca-4b05-8251-418fa7a5ac2a'),
	(2,'super-table','2.0.9','2.0.4',NULL,'unknown',1,NULL,'2018-09-20 21:26:24','2018-09-20 21:26:24','2018-09-23 23:06:01','8bd2b882-3bd0-4106-9f1a-c50ed4eb4960');
ALTER TABLE `plugins` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `migrations` WRITE;
ALTER TABLE `migrations` DISABLE KEYS;
INSERT INTO `migrations` (`id`, `pluginId`, `type`, `name`, `applyTime`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,NULL,'app','Install','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','4a8723cf-6eb9-46db-97c4-3dfe268aa8d3'),
	(2,NULL,'app','m150403_183908_migrations_table_changes','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','cecf21ba-0855-4d38-b8d5-a66f5da575ba'),
	(3,NULL,'app','m150403_184247_plugins_table_changes','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','504b7fbc-5f2b-477e-8212-c59083921845'),
	(4,NULL,'app','m150403_184533_field_version','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','15b92eb0-d82f-46c9-af9f-8bca7f752ec9'),
	(5,NULL,'app','m150403_184729_type_columns','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','e162a948-2407-4e68-8a23-4f84d228b4ad'),
	(6,NULL,'app','m150403_185142_volumes','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','d4b9fdf5-b976-406f-9984-35e36affa291'),
	(7,NULL,'app','m150428_231346_userpreferences','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','02ada43c-ed9e-429f-ad94-297a89646cc0'),
	(8,NULL,'app','m150519_150900_fieldversion_conversion','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','58db31e3-240b-4866-97ad-aa4329b9d971'),
	(9,NULL,'app','m150617_213829_update_email_settings','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','fd8eda16-ba97-4ff0-b289-4b741b85da5a'),
	(10,NULL,'app','m150721_124739_templatecachequeries','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','d5a953ed-c6ea-4017-8ac5-146ec8a25a35'),
	(11,NULL,'app','m150724_140822_adjust_quality_settings','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','d7df0a4e-0de2-4044-8a5a-b1a93f0bdd77'),
	(12,NULL,'app','m150815_133521_last_login_attempt_ip','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','9e35ec82-56f0-4cb1-93d7-cf27e9bbad80'),
	(13,NULL,'app','m151002_095935_volume_cache_settings','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','174782df-d25a-47a1-bf86-764d037779f6'),
	(14,NULL,'app','m151005_142750_volume_s3_storage_settings','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','31ad8fd6-2e0a-43e0-9546-dfc9b32094b6'),
	(15,NULL,'app','m151016_133600_delete_asset_thumbnails','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','d262b0c5-0990-4d40-a3b3-d6064e7b5866'),
	(16,NULL,'app','m151209_000000_move_logo','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','fda583b3-dcdd-4be0-884f-f4987502ba96'),
	(17,NULL,'app','m151211_000000_rename_fileId_to_assetId','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','9c3e159b-a852-4e47-a8de-a66613a45b97'),
	(18,NULL,'app','m151215_000000_rename_asset_permissions','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','18df75a5-f78d-4e73-a60a-862cea910ebf'),
	(19,NULL,'app','m160707_000001_rename_richtext_assetsource_setting','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','c9d9a0bb-2c16-41b1-ac48-fb5afe0fd68b'),
	(20,NULL,'app','m160708_185142_volume_hasUrls_setting','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','5d401f5e-e175-4b93-9a5a-b7e142dceede'),
	(21,NULL,'app','m160714_000000_increase_max_asset_filesize','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','63f36b34-31e7-4785-96a5-f796863f7b9e'),
	(22,NULL,'app','m160727_194637_column_cleanup','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','8e792d45-e4aa-4e23-a955-8af1b868fa01'),
	(23,NULL,'app','m160804_110002_userphotos_to_assets','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','45fe04bf-1313-4f7f-baa3-f07d303c7b29'),
	(24,NULL,'app','m160807_144858_sites','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','dd63883c-24aa-4454-8d22-7a0fc75b3b98'),
	(25,NULL,'app','m160829_000000_pending_user_content_cleanup','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','775b4bb9-d968-4f6c-94e4-99b60e63038d'),
	(26,NULL,'app','m160830_000000_asset_index_uri_increase','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','2ec09a9f-55e3-4db5-b6d5-bc6c1e4dba0a'),
	(27,NULL,'app','m160912_230520_require_entry_type_id','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','d9cc9868-df82-4451-a18e-613c6781af9d'),
	(28,NULL,'app','m160913_134730_require_matrix_block_type_id','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','cd11090b-d036-4ced-915f-4178f9e2dafe'),
	(29,NULL,'app','m160920_174553_matrixblocks_owner_site_id_nullable','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','413535ce-cf0e-4605-9d15-6fd6d61fabca'),
	(30,NULL,'app','m160920_231045_usergroup_handle_title_unique','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','385b8949-846f-4b4a-a761-2c870a3283f2'),
	(31,NULL,'app','m160925_113941_route_uri_parts','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','8c503978-3323-41c8-8de8-4a18670e7672'),
	(32,NULL,'app','m161006_205918_schemaVersion_not_null','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','336cb6a9-e832-4974-a2b4-5aa335cc2464'),
	(33,NULL,'app','m161007_130653_update_email_settings','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','43634c1d-5b61-44ad-8d46-813886d22395'),
	(34,NULL,'app','m161013_175052_newParentId','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','1398e26b-e738-49a4-9a2d-e8d7e02cc210'),
	(35,NULL,'app','m161021_102916_fix_recent_entries_widgets','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','85be79f3-7203-4042-a552-1e2ad2384db8'),
	(36,NULL,'app','m161021_182140_rename_get_help_widget','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','72dac9ff-8e40-4b22-bd0f-356ac928ef68'),
	(37,NULL,'app','m161025_000000_fix_char_columns','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','9ae7738b-5164-4a91-b78c-ac58d1889664'),
	(38,NULL,'app','m161029_124145_email_message_languages','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','3144e1a3-f360-43f5-95cb-f805608d9446'),
	(39,NULL,'app','m161108_000000_new_version_format','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','d2a8ef1c-b9ad-4854-b7ef-b1929a489d48'),
	(40,NULL,'app','m161109_000000_index_shuffle','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','ada6b42b-cd05-4d15-b2c3-5ffd6729c5b4'),
	(41,NULL,'app','m161122_185500_no_craft_app','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','fd58386a-651a-4fcb-822f-d633212e8f4b'),
	(42,NULL,'app','m161125_150752_clear_urlmanager_cache','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','56d23870-357c-400b-8d58-38e397e18ddb'),
	(43,NULL,'app','m161220_000000_volumes_hasurl_notnull','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','733e6a4b-5ad2-452a-a987-b36420c61674'),
	(44,NULL,'app','m170114_161144_udates_permission','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','25e830e3-e82d-4c11-8b77-e18704d22464'),
	(45,NULL,'app','m170120_000000_schema_cleanup','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','f55f3cd1-19cd-476a-92b6-ead69b817261'),
	(46,NULL,'app','m170126_000000_assets_focal_point','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','bdef404c-49ba-4def-89fd-3a8bab4c535b'),
	(47,NULL,'app','m170206_142126_system_name','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','04758a8a-6772-48f3-94af-39b2d2f4b48a'),
	(48,NULL,'app','m170217_044740_category_branch_limits','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','c2e4b5ce-d05c-45c4-a6b1-e10f35fafe0b'),
	(49,NULL,'app','m170217_120224_asset_indexing_columns','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','8a1936bc-52c9-4e6f-a749-0830ea4269f8'),
	(50,NULL,'app','m170223_224012_plain_text_settings','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','730c3e34-5a1a-43ba-a9b8-ba1916fabae1'),
	(51,NULL,'app','m170227_120814_focal_point_percentage','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','113ee5c7-c2f2-4e5e-81bb-ae1ecf68d715'),
	(52,NULL,'app','m170228_171113_system_messages','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','6cb24920-d67e-46ce-a283-7489b702a690'),
	(53,NULL,'app','m170303_140500_asset_field_source_settings','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','93f1dabd-2e0e-40f4-a71a-3d6b74235120'),
	(54,NULL,'app','m170306_150500_asset_temporary_uploads','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','06315a4b-f431-49bf-bf58-830067170d0e'),
	(55,NULL,'app','m170414_162429_rich_text_config_setting','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','40f8e0e7-42e1-4d21-9f14-4ebe73aa09e8'),
	(56,NULL,'app','m170523_190652_element_field_layout_ids','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','834fbec6-0b13-4152-a0e7-d7cf0022e054'),
	(57,NULL,'app','m170612_000000_route_index_shuffle','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','cd2b33c8-83a9-44cc-afb6-5ee86759fe89'),
	(58,NULL,'app','m170621_195237_format_plugin_handles','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','742c4d6d-7e2d-4cb2-afb9-ecfb06112805'),
	(59,NULL,'app','m170630_161028_deprecation_changes','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','9239da4b-7c1d-48f1-8cba-d5be7f2b2829'),
	(60,NULL,'app','m170703_181539_plugins_table_tweaks','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','f4dcd8ae-6dcc-418a-9d49-b10832158a2e'),
	(61,NULL,'app','m170704_134916_sites_tables','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','42f29695-5680-4117-9e3d-d8a82922bc7a'),
	(62,NULL,'app','m170706_183216_rename_sequences','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','75a7da92-d192-425a-95ab-00ebb754dd83'),
	(63,NULL,'app','m170707_094758_delete_compiled_traits','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','a675e06c-9c82-49b8-9a42-26308e5b569c'),
	(64,NULL,'app','m170731_190138_drop_asset_packagist','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','6c15a0ef-bab6-4f5f-99c5-92e19b45c05a'),
	(65,NULL,'app','m170810_201318_create_queue_table','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','cf700535-ee44-4360-9ae0-a29f08f54095'),
	(66,NULL,'app','m170816_133741_delete_compiled_behaviors','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','bef50937-f9a9-498c-91b5-21f99c2cd379'),
	(67,NULL,'app','m170821_180624_deprecation_line_nullable','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','1fb37c18-408c-4a81-a987-cae2329908e1'),
	(68,NULL,'app','m170903_192801_longblob_for_queue_jobs','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','6b34d8f4-8f65-4530-8771-a57f26d507f3'),
	(69,NULL,'app','m170914_204621_asset_cache_shuffle','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','3e98358f-63d0-49dc-a7eb-fcdcd0f21f85'),
	(70,NULL,'app','m171011_214115_site_groups','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','dafac908-e5fe-4398-987a-2aff3b65c862'),
	(71,NULL,'app','m171012_151440_primary_site','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','2db2c7ba-a4cd-4e8e-bce5-9e94ebca0b6f'),
	(72,NULL,'app','m171013_142500_transform_interlace','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','ba04eff2-149d-4ed2-9524-0cb4cfa7fbc3'),
	(73,NULL,'app','m171016_092553_drop_position_select','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','95aab30d-0ce0-4d97-a2c1-27adef20605e'),
	(74,NULL,'app','m171016_221244_less_strict_translation_method','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','c559345a-4e3c-4ff1-bda2-ddb6afc0f6da'),
	(75,NULL,'app','m171107_000000_assign_group_permissions','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','593894fa-b197-490d-ac15-d5f590d8929f'),
	(76,NULL,'app','m171117_000001_templatecache_index_tune','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','aff5f713-61dd-47e9-a715-eb4d20ffb2c0'),
	(77,NULL,'app','m171126_105927_disabled_plugins','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','d5c68e52-6c68-4f56-b65e-5f61b4c0a12c'),
	(78,NULL,'app','m171130_214407_craftidtokens_table','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','cae94fa8-56d3-4fd8-8518-6fec5c92adac'),
	(79,NULL,'app','m171202_004225_update_email_settings','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','2a24ef06-1dc1-4ee2-842e-2ffd4a3a7387'),
	(80,NULL,'app','m171204_000001_templatecache_index_tune_deux','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','ece20f6f-7849-4300-bf66-352d5a31eae1'),
	(81,NULL,'app','m171205_130908_remove_craftidtokens_refreshtoken_column','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','61ed55d9-b46d-423c-bb31-227c58602998'),
	(82,NULL,'app','m171218_143135_longtext_query_column','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','497c77db-642f-435b-a91d-3ac01d28f92b'),
	(83,NULL,'app','m171231_055546_environment_variables_to_aliases','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','43a46405-1b56-4355-9044-99a105b7f71d'),
	(84,NULL,'app','m180113_153740_drop_users_archived_column','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','155a1d5b-63ca-4f83-aeb9-9117c07c6f70'),
	(85,NULL,'app','m180122_213433_propagate_entries_setting','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','57549411-362b-4bcb-ac14-88c6831dd74a'),
	(86,NULL,'app','m180124_230459_fix_propagate_entries_values','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','d80c106d-723f-46d3-ae54-cc62d9b7aa38'),
	(87,NULL,'app','m180128_235202_set_tag_slugs','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','32adcabd-2686-4daf-a31f-38ba2153139c'),
	(88,NULL,'app','m180202_185551_fix_focal_points','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','904ff650-cf55-4f28-8397-1918d631df9c'),
	(89,NULL,'app','m180217_172123_tiny_ints','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','e574c2ed-f8b9-4473-9596-77ed551193aa'),
	(90,NULL,'app','m180321_233505_small_ints','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','df45176b-e321-4e70-8734-b0475c345c18'),
	(91,NULL,'app','m180328_115523_new_license_key_statuses','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','00e19b10-c645-4f45-aa73-775b508e3649'),
	(92,NULL,'app','m180404_182320_edition_changes','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','e8899627-96fd-4c7a-b7db-81f2e7084580'),
	(93,NULL,'app','m180411_102218_fix_db_routes','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','c6f60dba-e897-48d5-bafd-32b16e5da332'),
	(94,NULL,'app','m180416_205628_resourcepaths_table','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','0f43bb00-ad42-40bc-bdcc-35ab42dc7465'),
	(95,NULL,'app','m180418_205713_widget_cleanup','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','803845d8-59e8-4b40-9c5c-0b8142a47a96'),
	(96,NULL,'app','m180824_193422_case_sensitivity_fixes','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','1400a019-8b0f-482b-8c92-a366ae2e83b2'),
	(97,NULL,'app','m180901_151639_fix_matrixcontent_tables','2018-09-18 20:53:53','2018-09-18 20:53:53','2018-09-18 20:53:53','219c8dae-0bd7-4fe5-ac37-c6ee74118603'),
	(98,1,'plugin','m180430_204710_remove_old_plugins','2018-09-19 08:08:43','2018-09-19 08:08:43','2018-09-19 08:08:43','b81213ae-4a34-49f2-b00f-f6aaaf1651c9'),
	(99,1,'plugin','Install','2018-09-19 08:08:43','2018-09-19 08:08:43','2018-09-19 08:08:43','3b06fa1a-ba5e-49bf-9367-f8c7ce3731e1'),
	(100,2,'plugin','Install','2018-09-20 21:26:24','2018-09-20 21:26:24','2018-09-20 21:26:24','625f982e-0504-44fb-9e9b-4e08d4ff5f5a'),
	(101,2,'plugin','m180210_000000_migrate_content_tables','2018-09-20 21:26:24','2018-09-20 21:26:24','2018-09-20 21:26:24','abb44805-7726-4c29-8098-7fda1629e6cc'),
	(102,2,'plugin','m180211_000000_type_columns','2018-09-20 21:26:24','2018-09-20 21:26:24','2018-09-20 21:26:24','6321c5a9-05a4-4af0-9929-d5a0a96ce7b2'),
	(103,2,'plugin','m180219_000000_sites','2018-09-20 21:26:24','2018-09-20 21:26:24','2018-09-20 21:26:24','7d528e9e-6d89-4742-956b-03d9dfe843f4'),
	(104,2,'plugin','m180220_000000_fix_context','2018-09-20 21:26:24','2018-09-20 21:26:24','2018-09-20 21:26:24','b3cfdcbb-c7ab-4eb0-ae80-6d06c95263fd'),
	(107,NULL,'content','m180922_195910_create_reactions_table','2018-09-24 11:30:24','2018-09-24 11:30:24','2018-09-24 11:30:24','29c986e7-f5d8-421d-aad6-fb1c1f71e8fa');
ALTER TABLE `migrations` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `queue` WRITE;
ALTER TABLE `queue` DISABLE KEYS;
ALTER TABLE `queue` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `recipe_reactions` WRITE;
ALTER TABLE `recipe_reactions` DISABLE KEYS;
ALTER TABLE `recipe_reactions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `relations` WRITE;
ALTER TABLE `relations` DISABLE KEYS;
INSERT INTO `relations` (`id`, `fieldId`, `sourceId`, `sourceSiteId`, `targetId`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(131,1,58,NULL,29,1,'2018-09-22 03:50:49','2018-09-22 03:50:49','7dd1c50a-7e44-4258-97e6-c246c64dd639'),
	(132,11,59,NULL,6,1,'2018-09-22 03:50:49','2018-09-22 03:50:49','4075dcfc-6779-4396-b58f-9a06699cffcf'),
	(135,1,48,NULL,26,1,'2018-09-22 03:52:35','2018-09-22 03:52:35','f67769f6-f832-4ca9-b303-6dd7f5d5fcba'),
	(136,1,37,NULL,25,1,'2018-09-22 03:52:56','2018-09-22 03:52:56','27efd372-6e47-47f9-882c-a43a31be97d5'),
	(137,1,17,NULL,18,1,'2018-09-22 03:53:49','2018-09-22 03:53:49','f87c6b6d-a786-4c27-934a-ac5a07dbca85'),
	(138,11,42,NULL,6,1,'2018-09-22 03:53:49','2018-09-22 03:53:49','e14eab63-744a-4988-9f2c-52ec8c942274'),
	(139,11,43,NULL,19,1,'2018-09-22 03:53:49','2018-09-22 03:53:49','406da726-f1d3-42e0-97ed-d21fa9725ea3'),
	(140,1,13,NULL,12,1,'2018-09-22 03:55:31','2018-09-22 03:55:31','38785401-cecb-4a54-b39a-105202324472'),
	(141,11,44,NULL,6,1,'2018-09-22 03:55:32','2018-09-22 03:55:32','a2f7b777-6b75-4574-931a-6c2674239bc9'),
	(142,11,45,NULL,8,1,'2018-09-22 03:55:32','2018-09-22 03:55:32','cdd74df3-43a3-4c05-b6ad-46e0e92fd6ec'),
	(143,1,55,NULL,28,1,'2018-09-22 03:58:27','2018-09-22 03:58:27','a0c43cd2-020c-47f6-8859-2223d9c19a2e'),
	(151,1,98,NULL,97,1,'2018-09-23 23:13:14','2018-09-23 23:13:14','fcca6aad-7680-4186-aa14-59abb7ca79bb'),
	(152,11,103,NULL,175,1,'2018-09-23 23:13:14','2018-09-23 23:13:14','4889a686-c7ab-4c2e-bbc9-3713fca78c2a'),
	(153,11,104,NULL,176,1,'2018-09-23 23:13:14','2018-09-23 23:13:14','9894074c-ed61-447a-a0ef-5e4f89484fc5'),
	(154,1,92,NULL,34,1,'2018-09-23 23:14:09','2018-09-23 23:14:09','00c1fb74-4c8a-40ca-8fae-fd92223b6761'),
	(155,11,93,NULL,177,1,'2018-09-23 23:14:09','2018-09-23 23:14:09','4ce1c6b7-4b39-4267-a4b9-2243dee182d4'),
	(156,11,94,NULL,178,1,'2018-09-23 23:14:09','2018-09-23 23:14:09','9c0e5931-ba0f-4a71-8bdb-b3be59b21d63'),
	(157,11,95,NULL,176,1,'2018-09-23 23:14:09','2018-09-23 23:14:09','ff8d30f2-d8f9-426c-a6af-0bab37f31045'),
	(158,1,79,NULL,33,1,'2018-09-23 23:16:19','2018-09-23 23:16:19','42314270-82b9-4c50-a426-25336da1b7ce'),
	(159,11,80,NULL,179,1,'2018-09-23 23:16:19','2018-09-23 23:16:19','7f7f0d1b-ea32-4b2e-8be2-09bcb9c65867'),
	(160,11,83,NULL,180,1,'2018-09-23 23:16:19','2018-09-23 23:16:19','b89eb382-955d-4c6a-ad46-cb6c4b468d18'),
	(161,11,84,NULL,181,1,'2018-09-23 23:16:19','2018-09-23 23:16:19','27a5f140-7ddd-49ac-a5ac-d1de1b615f50'),
	(162,11,85,NULL,182,1,'2018-09-23 23:16:19','2018-09-23 23:16:19','db03f847-af41-416d-a512-d55006f4d275'),
	(163,11,91,NULL,176,1,'2018-09-23 23:16:19','2018-09-23 23:16:19','26352b6d-f759-47b7-97fd-4822edb79ba6'),
	(167,1,71,NULL,31,1,'2018-09-23 23:17:09','2018-09-23 23:17:09','0eef6214-89dd-4513-9547-5a84e046bcae'),
	(168,11,72,NULL,185,1,'2018-09-23 23:17:09','2018-09-23 23:17:09','21571eef-ac9a-4779-9549-9ca39c03c264'),
	(169,11,73,NULL,180,1,'2018-09-23 23:17:09','2018-09-23 23:17:09','e3c9095b-da0c-4792-be1c-c869869c9a07'),
	(170,1,64,NULL,30,1,'2018-09-23 23:18:13','2018-09-23 23:18:13','d24b5135-556d-4721-98a5-922a574ca672'),
	(171,11,66,NULL,186,1,'2018-09-23 23:18:13','2018-09-23 23:18:13','ded48561-3b15-43a9-a5c5-50a8895ccf4d'),
	(172,11,68,NULL,183,1,'2018-09-23 23:18:13','2018-09-23 23:18:13','c067a1f4-8992-4a77-82cf-f2770ba153e9'),
	(173,11,69,NULL,182,1,'2018-09-23 23:18:13','2018-09-23 23:18:13','2c4ad160-4c03-4876-9dc2-5a9c51960ec2'),
	(174,1,51,NULL,27,1,'2018-09-23 23:18:55','2018-09-23 23:18:55','ad93b652-80c8-4fe4-b113-c008da34571f'),
	(175,11,53,NULL,187,1,'2018-09-23 23:18:55','2018-09-23 23:18:55','3929a63a-03a7-4962-b781-c478c550e125'),
	(180,1,9,NULL,16,1,'2018-09-24 00:17:23','2018-09-24 00:17:23','98994303-f2f9-423b-82f7-0817a06a39c1'),
	(181,11,46,NULL,4,1,'2018-09-24 00:17:23','2018-09-24 00:17:23','6d13197b-7304-4c1d-9249-75a754309881'),
	(182,11,47,NULL,8,1,'2018-09-24 00:17:23','2018-09-24 00:17:23','e98a3a27-783d-4589-bf79-85f227e6a390'),
	(183,1,105,NULL,96,1,'2018-09-24 00:17:33','2018-09-24 00:17:33','01380e89-3e5c-4fba-8cd4-d987821d173f'),
	(184,11,155,NULL,4,1,'2018-09-24 00:17:33','2018-09-24 00:17:33','df28b359-3c29-4f15-af0a-6c2889795fd5'),
	(185,11,156,NULL,174,1,'2018-09-24 00:17:33','2018-09-24 00:17:33','8e185e7a-e2b7-4aee-bd35-a41ff90a22dc'),
	(186,1,74,NULL,32,1,'2018-09-24 00:17:40','2018-09-24 00:17:40','e885d047-e539-4708-bc4f-132129b56f33'),
	(187,11,75,NULL,183,1,'2018-09-24 00:17:40','2018-09-24 00:17:40','1bf06937-a21d-4988-8530-1d216ab02370'),
	(188,11,76,NULL,184,1,'2018-09-24 00:17:40','2018-09-24 00:17:40','b85e9bde-7422-4b02-8578-5dbfc18b15f0'),
	(189,11,77,NULL,187,1,'2018-09-24 00:17:40','2018-09-24 00:17:40','e90451bb-8d73-4661-85e4-2e92e68cd2aa');
ALTER TABLE `relations` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `resourcepaths` WRITE;
ALTER TABLE `resourcepaths` DISABLE KEYS;
ALTER TABLE `resourcepaths` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `sites` WRITE;
ALTER TABLE `sites` DISABLE KEYS;
INSERT INTO `sites` (`id`, `groupId`, `primary`, `name`, `handle`, `language`, `hasUrls`, `baseUrl`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,1,1,'On the Rocks','default','en',1,'@web/',1,'2018-09-18 20:53:52','2018-09-18 20:53:52','ec998cec-37ac-4b51-8882-e6d2075e4cd9');
ALTER TABLE `sites` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `routes` WRITE;
ALTER TABLE `routes` DISABLE KEYS;
ALTER TABLE `routes` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `searchindex` WRITE;
ALTER TABLE `searchindex` DISABLE KEYS;
INSERT INTO `searchindex` (`elementId`, `attribute`, `fieldId`, `siteId`, `keywords`) VALUES 
	(1,'username',0,1,' admin '),
	(1,'firstname',0,1,''),
	(1,'lastname',0,1,''),
	(1,'fullname',0,1,''),
	(1,'email',0,1,' admin ontherocks app '),
	(1,'slug',0,1,''),
	(191,'filename',0,1,' veronica jpg '),
	(190,'email',0,1,' veronica ontherocks app '),
	(190,'field',7,1,' bend or '),
	(1,'field',7,1,''),
	(164,'fullname',0,1,' cathie '),
	(164,'username',0,1,' cathie '),
	(164,'firstname',0,1,' cathie '),
	(164,'lastname',0,1,''),
	(4,'field',1,1,' alcohol alcohol bottles bar 613182 '),
	(4,'field',2,1,' gin is liquor which derives its predominant flavor from juniper berries gin is one of the broadest categories of spirits all of various origins styles and flavor profiles that revolve around juniper as a common ingredient from its earliest origins in the middle ages the drink has evolved from a herbal medicine to an object of commerce in the spirits industry gin was developed based on the older dutch liquor jenever and became popular in great britain particularly in london when william of orange became king william iii ii and i of england scotland and ireland '),
	(4,'slug',0,1,' gin '),
	(4,'title',0,1,' gin '),
	(162,'lastname',0,1,''),
	(162,'username',0,1,' bjorn '),
	(162,'firstname',0,1,' bjorn '),
	(162,'field',7,1,' bend or '),
	(6,'field',1,1,' alcoholic beverage bottle close up 162986 '),
	(6,'field',2,1,' vodka is a distilled beverage composed primarily of water and ethanol but sometimes with traces of impurities and flavorings traditionally vodka is made through the distillation of cereal grains or potatoes that have been fermented though some modern brands such as ciroc cooranbong and bombora use fruits or sugar since the 1890s the standard polish russian belarusian czech estonian hungarian icelandic latvian lithuanian norwegian slovak swedish and ukrainian vodkas are 40% abv or alcohol by volume 80 us proof a percentage widely misattributed to russian chemist dmitri mendeleev meanwhile the european union has established a minimum of 37 5% abv for any european vodka to be named as such products sold as vodka in the united states must have a minimum alcohol content of 40% even with these loose restrictions most vodka sold contains 40% abv vodka is traditionally drunk neat not mixed with water ice or other mixer though it is often served freezer chilled in the vodka belt countries of belarus estonia finland iceland lithuania latvia norway poland and russia it is also used in cocktails and mixed drinks such as the vodka martini cosmopolitan vodka tonic screwdriver greyhound black or white russian moscow mule bloody mary and bloody caesar '),
	(6,'slug',0,1,' vodka '),
	(6,'title',0,1,' vodka '),
	(163,'title',0,1,' bjorn '),
	(164,'field',7,1,' bend or '),
	(162,'fullname',0,1,' bjorn '),
	(190,'slug',0,1,''),
	(8,'field',1,1,' tonicwater indian 500ml '),
	(8,'field',2,1,' tonic water or indian tonic water is a carbonated soft drink in which quinine is dissolved originally used as a prophylactic against malaria tonic water usually now has a significantly lower quinine content and is consumed for its distinctive bitter flavor it is often used in mixed drinks particularly in gin and tonic '),
	(8,'slug',0,1,' tonic water '),
	(8,'title',0,1,' tonic water '),
	(9,'field',1,1,' gin and tonic '),
	(9,'field',2,1,' a gin and tonic is a highball cocktail made with gin and tonic water poured over ice it is usually garnished with a slice or wedge of lime the amount of gin varies according to taste suggested ratios of gin to tonic are between 1 1 and 1 3 in some countries e g uk gin and tonic is also marketed pre mixed in single serving cans in the united states most bars use soda out of a gun that in no way shape or form resembles quinine water according to bartender dale degroff to get a real gin and tonic degroff recommends specifying bottled tonic alternatively one can add tonic syrup to soda water gin and tonic made with bombay sapphire london dry gin and schweppes indian tonic garnished with slices of lime the drink is a particular phenomenon as its taste is quite different from the taste of its constituent liquids which are rather bitter the chemical structures of both ingredients are of a similar molecular shape and attract each other shielding the bitter taste a gin and tonic with ice and lemon it is commonly referred to as a g and t in the uk us canada australia new zealand and ireland 7 in some parts of the world it is called a gin tonic e g germany spain the netherlands japan ジン・トニック phonetically gin tonic some brands will replace the word gin with their own brand or initial in recipes for instance sapphire and tonic for bombay sapphire hendrick s and tonic for hendrick s gin garnished with cucumber to further distinguish it or t t for tanqueray '),
	(9,'field',3,1,' 1 part gin 2 parts tonic water '),
	(9,'field',6,1,' combine gin and tonic water in a highball glass over ice combine gin and tonic water in a highball glass over ice garnish with a lime garnish with a lime '),
	(9,'slug',0,1,' gin and tonic '),
	(9,'title',0,1,' gin and tonic '),
	(12,'filename',0,1,' vodka tonic jpg '),
	(12,'extension',0,1,' jpg '),
	(12,'kind',0,1,' image '),
	(12,'slug',0,1,''),
	(12,'title',0,1,' vodka tonic '),
	(13,'field',1,1,' vodka tonic '),
	(13,'field',2,1,' a vodka tonic is an alcoholic drink made with varying proportions of vodka and tonic water vodka tonics are frequently garnished with a slice of lime or lemon one commonly used recipe is one part vodka and one part tonic water in a tumbler over ice with a generous lime wedge squeezed into it the drink is referenced in the song goodbye yellow brick road by elton john '),
	(13,'field',3,1,' 1 part vodka 2 parts tonic water '),
	(13,'field',6,1,' combine vodka and tonic water in a highball glass over ice combine vodka and tonic water in a highball glass over ice garnish with a lemon garnish with a lemon '),
	(48,'field',6,1,' combine lemonade and iced tea in a highball or tall glass combine lemonade and iced tea in a highball or tall glass add ice and stir until chilled add ice and stir until chilled '),
	(13,'slug',0,1,' vodka tonic '),
	(13,'title',0,1,' vodka tonic '),
	(16,'filename',0,1,' gin and tonic jpg '),
	(16,'extension',0,1,' jpg '),
	(16,'kind',0,1,' image '),
	(16,'slug',0,1,''),
	(16,'title',0,1,' gin and tonic '),
	(17,'field',1,1,' salty dog '),
	(17,'field',2,1,' a salty dog is a cocktail of gin or vodka and grapefruit juice served in a highball glass with a salted rim the salt is the only difference between a salty dog and a greyhound vodka may be used as a substitute for gin nevertheless it is historically a gin drink '),
	(17,'field',3,1,' 1 part vodka 1 part grapefruit juice '),
	(17,'field',6,1,' salt the rim of the glass salt the rim of the glass pour ingredients in glass over ice pour ingredients in glass over ice garnish with a grapefruit wedge garnish with a grapefruit wedge '),
	(17,'slug',0,1,' salty dog '),
	(17,'title',0,1,' salty dog '),
	(9,'field',8,1,' highball '),
	(13,'field',8,1,' highball '),
	(17,'field',8,1,' highball '),
	(18,'filename',0,1,' salty dog jpg '),
	(18,'extension',0,1,' jpg '),
	(18,'kind',0,1,' image '),
	(18,'slug',0,1,''),
	(18,'title',0,1,' salty dog '),
	(19,'field',1,1,''),
	(19,'field',2,1,''),
	(19,'slug',0,1,' grapefruit juice '),
	(19,'title',0,1,' grapefruit juice '),
	(26,'slug',0,1,''),
	(26,'title',0,1,' arnold palmer '),
	(26,'kind',0,1,' image '),
	(26,'extension',0,1,' jpg '),
	(26,'filename',0,1,' arnold palmer jpg '),
	(25,'title',0,1,' apple cider '),
	(25,'slug',0,1,''),
	(25,'kind',0,1,' image '),
	(25,'extension',0,1,' jpg '),
	(25,'filename',0,1,' apple cider jpg '),
	(27,'filename',0,1,' irish coffee jpg '),
	(27,'extension',0,1,' jpg '),
	(27,'kind',0,1,' image '),
	(27,'slug',0,1,''),
	(27,'title',0,1,' irish coffee '),
	(28,'filename',0,1,' lemonade jpg '),
	(28,'extension',0,1,' jpg '),
	(28,'kind',0,1,' image '),
	(28,'slug',0,1,''),
	(28,'title',0,1,' lemonade '),
	(29,'filename',0,1,' lemondrop jpg '),
	(29,'extension',0,1,' jpg '),
	(29,'kind',0,1,' image '),
	(29,'slug',0,1,''),
	(29,'title',0,1,' lemondrop '),
	(30,'filename',0,1,' margarita jpg '),
	(30,'extension',0,1,' jpg '),
	(30,'kind',0,1,' image '),
	(30,'slug',0,1,''),
	(30,'title',0,1,' margarita '),
	(31,'filename',0,1,' mimosa jpg '),
	(31,'extension',0,1,' jpg '),
	(31,'kind',0,1,' image '),
	(31,'slug',0,1,''),
	(31,'title',0,1,' mimosa '),
	(32,'filename',0,1,' old fashioned jpg '),
	(32,'extension',0,1,' jpg '),
	(32,'kind',0,1,' image '),
	(32,'slug',0,1,''),
	(32,'title',0,1,' old fashioned '),
	(33,'filename',0,1,' sangria jpg '),
	(33,'extension',0,1,' jpg '),
	(33,'kind',0,1,' image '),
	(33,'slug',0,1,''),
	(33,'title',0,1,' sangria '),
	(34,'filename',0,1,' aperol spritz jpg '),
	(34,'extension',0,1,' jpg '),
	(34,'kind',0,1,' image '),
	(34,'slug',0,1,''),
	(34,'title',0,1,' aperol spritz '),
	(164,'slug',0,1,''),
	(165,'filename',0,1,' cathie jpg '),
	(165,'extension',0,1,' jpg '),
	(165,'kind',0,1,' image '),
	(37,'field',1,1,' apple cider '),
	(37,'field',2,1,' apple cider is an unfiltered unsweetened apple juice most present day apple juice is pasteurized and filtered apple cider also called sweet cider or soft cider or simply cider is the name used in the united states and parts of canada for an unfiltered unsweetened non alcoholic beverage made from apples though typically referred to simply as cider in those areas it is not to be confused with the alcoholic beverage known as cider throughout most of the world called hard cider or just cider in north america it is the official state beverage of new hampshire it is the liquid extracted from an apple and all its components that is then boiled to concentration the liquid can be extracted from the apple itself the apple core the trimmings from apples or apple culls once pressed mainly at farmsteads and local mills apple cider is easy and inexpensive to make it is typically opaque due to fine apple particles in suspension and generally tangier than commercial filtered apple juice but this depends on the variety of apples used cider is typically pasteurized to kill bacteria and extend its shelf life but untreated cider is common in either form apple cider is seasonally produced in autumn it is traditionally served on the halloween thanksgiving christmas and various new year s eve holidays sometimes heated and mulled '),
	(37,'field',3,1,' 10 apple 3 4 cup white vinegar '),
	(37,'field',6,1,' place apples in a large stockpot and add enough water cover by at least 2 inches place apples in a large stockpot and add enough water cover by at least 2 inches stir in sugar cinnamon and allspice stir in sugar cinnamon and allspice bring to a boil and boil uncovered for 1 hour bring to a boil and boil uncovered for 1 hour cover pot reduce heat and simmer for 2 hours cover pot reduce heat and simmer for 2 hours strain apple mixture though a fine mesh sieve discard solids strain apple mixture though a fine mesh sieve discard solids drain cider again though a cheesecloth lined sieve drain cider again though a cheesecloth lined sieve refrigerate until cold refrigerate until cold '),
	(37,'field',8,1,' mug '),
	(48,'field',2,1,' the arnold palmer beverage is a non alcoholic combination of iced tea and lemonade created and made popular by american golfer arnold palmer an alcoholic version of the beverage generally made with vodka is often referred to as a john daly however millercoors began marketing and distributing a commercially available malt based version of the beverage under the arnold palmer spiked name in early 2018 '),
	(48,'field',9,1,' 5 fl oz prepared lemonade 5 fl oz prepared iced tea '),
	(48,'field',1,1,' arnold palmer '),
	(37,'slug',0,1,' apple cider '),
	(37,'title',0,1,' apple cider '),
	(9,'field',9,1,' gin 1 part gin tonic water 2 parts tonic water '),
	(13,'field',9,1,' vodka 1 part vodka tonic water 2 parts tonic water '),
	(17,'field',9,1,' vodka 1 part vodka grapefruit juice 1 part grapefruit juice '),
	(37,'field',9,1,' 10 apples quartered 3 4 cup white vinegar '),
	(40,'field',10,1,' 10 apples quartered '),
	(40,'field',11,1,''),
	(40,'slug',0,1,''),
	(41,'field',10,1,' 3 4 cup white vinegar '),
	(41,'field',11,1,''),
	(41,'slug',0,1,''),
	(42,'field',10,1,' 1 part vodka '),
	(42,'field',11,1,' vodka '),
	(42,'slug',0,1,''),
	(43,'field',10,1,' 1 part grapefruit juice '),
	(43,'field',11,1,' grapefruit juice '),
	(43,'slug',0,1,''),
	(44,'field',10,1,' 1 part vodka '),
	(44,'field',11,1,' vodka '),
	(44,'slug',0,1,''),
	(45,'field',10,1,' 2 parts tonic water '),
	(45,'field',11,1,' tonic water '),
	(45,'slug',0,1,''),
	(46,'field',10,1,' 1 part gin '),
	(46,'field',11,1,' gin '),
	(46,'slug',0,1,''),
	(47,'field',10,1,' 2 parts tonic water '),
	(47,'field',11,1,' tonic water '),
	(47,'slug',0,1,''),
	(48,'field',8,1,' highball footed '),
	(49,'field',10,1,' 5 fl oz prepared lemonade '),
	(49,'field',11,1,''),
	(49,'slug',0,1,''),
	(50,'field',10,1,' 5 fl oz prepared iced tea '),
	(50,'field',11,1,''),
	(50,'slug',0,1,''),
	(48,'slug',0,1,' arnold palmer '),
	(48,'title',0,1,' arnold palmer '),
	(51,'field',1,1,' irish coffee '),
	(51,'field',9,1,' 1 5 fl oz irish cream liqueur whiskey 1 5 fl oz irish whiskey 1 cup hot brewed coffee '),
	(51,'field',6,1,' in a coffee mug combine irish cream and irish whiskey in a coffee mug combine irish cream and irish whiskey fill mug with coffee fill mug with coffee top with a dab of whipped cream and a dash of nutmeg top with a dab of whipped cream and a dash of nutmeg '),
	(51,'field',2,1,' irish coffee irish caife gaelach is a cocktail consisting of hot coffee irish whiskey and sugar some recipes specify that brown sugar should be used stirred and topped with thick cream the coffee is drunk through the cream the original recipe explicitly uses cream that has not been whipped although drinks made with whipped cream are often sold as irish coffee the term irish coffee is also sometimes used colloquially to refer to alcoholic coffee drinks in general '),
	(51,'field',8,1,' irish coffee '),
	(52,'field',10,1,' 1 5 fl oz irish cream liqueur '),
	(52,'field',11,1,''),
	(52,'slug',0,1,''),
	(53,'field',10,1,' 1 5 fl oz irish whiskey '),
	(53,'field',11,1,' whiskey '),
	(53,'slug',0,1,''),
	(54,'field',10,1,' 1 cup hot brewed coffee '),
	(54,'field',11,1,''),
	(54,'slug',0,1,''),
	(51,'slug',0,1,' irish coffee '),
	(51,'title',0,1,' irish coffee '),
	(55,'field',1,1,' lemonade '),
	(55,'field',9,1,' 1 3 4 cups white sugar 8 cups water '),
	(55,'field',6,1,' in a small saucepan combine sugar and 1 cup water in a small saucepan combine sugar and 1 cup water bring to boil and stir to dissolve sugar bring to boil and stir to dissolve sugar allow to cool to room temperature then cover and refrigerate until chilled allow to cool to room temperature then cover and refrigerate until chilled remove seeds from lemon juice but leave pulp remove seeds from lemon juice but leave pulp in pitcher stir together chilled syrup lemon juice and remaining 7 cups water in pitcher stir together chilled syrup lemon juice and remaining 7 cups water '),
	(55,'field',2,1,' lemonade can be any one of a variety of sweetened beverages found throughout the world but which are all characterized by a lemon flavor most lemonade varieties can be separated into two distinct types cloudy or clear each is known simply as lemonade or a cognate in countries where dominant cloudy lemonade generally found in north america and south asia is traditionally a homemade drink using lemon juice water and a sweetener such as cane sugar or honey in the united kingdom and australia clear lemonade which is typically also carbonated dominates a popular cloudy variation is pink lemonade made with added fruit flavors such as raspberry or strawberry and giving the drink its distinctive pink color the ade suffix may also be applied to other similar drinks made with different fruits such as limeade orangeade or cherryade alcoholic varieties are known as hard lemonade '),
	(55,'field',8,1,' beverage '),
	(56,'field',10,1,' 1 3 4 cups white sugar '),
	(56,'field',11,1,''),
	(56,'slug',0,1,''),
	(57,'field',10,1,' 8 cups water '),
	(57,'field',11,1,''),
	(57,'slug',0,1,''),
	(55,'slug',0,1,' lemonade '),
	(55,'title',0,1,' lemonade '),
	(58,'field',1,1,' lemondrop '),
	(58,'field',9,1,' vodka 2 cups frozen vodka 1 2 cup freshly squeezed lemon juice 1 2 cup superfine sugar 1 lemon thinly sliced ice '),
	(58,'field',6,1,' combine the vodka lemon juice and sugar and pour into a cocktail shaker with ice combine the vodka lemon juice and sugar and pour into a cocktail shaker with ice pour into martini glasses and garnish with lemon slices pour into martini glasses and garnish with lemon slices '),
	(58,'field',2,1,' a lemon drop is a vodka based cocktail that has a lemony sweet and sour flavor prepared using lemon juice triple sec and simple syrup it has been described as a variant of or as a take on the vodka martini it is typically prepared and served straight up chilled with ice and strained the drink was invented sometime in the 1970s by norman jay hobday the founder and proprietor of henry africa s bar in san francisco california some variations of the drink exist such as blueberry and raspberry lemon drops it is served at some bars and restaurants in the united states and in such establishments in other areas of the world '),
	(58,'field',8,1,' martini '),
	(59,'field',10,1,' 2 cups frozen vodka '),
	(59,'field',11,1,' vodka '),
	(59,'slug',0,1,''),
	(60,'field',10,1,' 1 2 cup freshly squeezed lemon juice '),
	(60,'field',11,1,''),
	(60,'slug',0,1,''),
	(61,'field',10,1,' 1 2 cup superfine sugar '),
	(61,'field',11,1,''),
	(61,'slug',0,1,''),
	(62,'field',10,1,' 1 lemon thinly sliced '),
	(62,'field',11,1,''),
	(62,'slug',0,1,''),
	(63,'field',10,1,' ice '),
	(63,'field',11,1,''),
	(63,'slug',0,1,''),
	(58,'slug',0,1,' lemondrop '),
	(58,'title',0,1,' lemondrop '),
	(64,'field',1,1,' margarita '),
	(64,'field',9,1,' ice cubes tequila 3 oz tequila 2 oz freshly squeezed lime juice simple syrup 1 oz simple syrup triple sec 1 2 tsp orange liqueur 1 tbsp lime salt sugar '),
	(64,'field',6,1,' fill a cocktail shaker with ice fill a cocktail shaker with ice add tequila lime juice simple syrup and orange liqueur add tequila lime juice simple syrup and orange liqueur cover and shake until mixed and chilled about 30 seconds in general the drink is ready by the time the shaker mists up cover and shake until mixed and chilled about 30 seconds in general the drink is ready by the time the shaker mists up place lime salt sugar on a plate place lime salt sugar on a plate press the rim of a chilled rocks or wine glass into the mixture to rim the edge press the rim of a chilled rocks or wine glass into the mixture to rim the edge strain margarita into the glass strain margarita into the glass '),
	(64,'field',2,1,' a margarita is a cocktail consisting of tequila orange liqueur and lime juice often served with salt on the rim of the glass the drink is served shaken with ice on the rocks blended with ice frozen margarita or without ice straight up although it has become acceptable to serve a margarita in a wide variety of glass types ranging from cocktail and wine glasses to pint glasses and even large schooners the drink is traditionally served in the eponymous margarita glass a stepped diameter variant of a cocktail glass or champagne coupe '),
	(64,'field',8,1,' margarita welled '),
	(65,'field',10,1,' ice cubes '),
	(65,'field',11,1,''),
	(65,'slug',0,1,''),
	(66,'field',10,1,' 3 oz tequila '),
	(66,'field',11,1,' tequila '),
	(66,'slug',0,1,''),
	(67,'field',10,1,' 2 oz freshly squeezed lime juice '),
	(67,'field',11,1,''),
	(67,'slug',0,1,''),
	(68,'field',10,1,' 1 oz simple syrup '),
	(68,'field',11,1,' simple syrup '),
	(68,'slug',0,1,''),
	(69,'field',10,1,' 1 2 tsp orange liqueur '),
	(69,'field',11,1,' triple sec '),
	(69,'slug',0,1,''),
	(70,'field',10,1,' 1 tbsp lime salt sugar '),
	(70,'field',11,1,''),
	(70,'slug',0,1,''),
	(64,'slug',0,1,' margarita '),
	(64,'title',0,1,' margarita '),
	(71,'field',1,1,' mimosa '),
	(71,'field',9,1,' champagne 3 parts champagne chilled orange juice 1 part orange juice '),
	(71,'field',6,1,' mix three parts of your favorite sparkling white to one part of your favorite orange juice mix three parts of your favorite sparkling white to one part of your favorite orange juice '),
	(71,'field',2,1,' a mimosa cocktail is composed of one part champagne or other sparkling wine and one part chilled citrus juice usually orange juice unless otherwise specified it is traditionally served in a tall champagne flute at brunch at weddings by the pint or as part of first class service on some passenger railways and airlines '),
	(71,'field',8,1,' flute '),
	(72,'field',10,1,' 3 parts champagne chilled '),
	(72,'field',11,1,' champagne '),
	(72,'slug',0,1,''),
	(73,'field',10,1,' 1 part orange juice '),
	(73,'field',11,1,' orange juice '),
	(73,'slug',0,1,''),
	(71,'slug',0,1,' mimosa '),
	(71,'title',0,1,' mimosa '),
	(74,'field',1,1,' old fashioned '),
	(74,'field',9,1,' simple syrup 2 tsp simple syrup bitters 2 to 3 dashes bitters whiskey 2 ounces 60ml rye whiskey '),
	(74,'field',6,1,' combine ingredients in a glass combine ingredients in a glass douse with a few drops of water douse with a few drops of water add several large ice cubes and stir rapidly with a bar spoon to chill add several large ice cubes and stir rapidly with a bar spoon to chill garnish if you like with a slice of orange and or a cherry garnish if you like with a slice of orange and or a cherry '),
	(74,'field',2,1,' the old fashioned is a cocktail made by muddling sugar with bitters then adding alcohol originally whiskey but now sometimes brandy and finally a twist of citrus rind it is traditionally served in a short round tumbler like glass which is called an old fashioned glass named after the drink the old fashioned developed during the 19th century and given its name in the 1880s is an iba official cocktail it is also one of six basic drinks listed in david a embury s the fine art of mixing drinks '),
	(74,'field',8,1,' old fashioned '),
	(75,'field',10,1,' 2 tsp simple syrup '),
	(75,'field',11,1,' simple syrup '),
	(75,'slug',0,1,''),
	(76,'field',10,1,' 2 to 3 dashes bitters '),
	(76,'field',11,1,' bitters '),
	(76,'slug',0,1,''),
	(77,'field',10,1,' 2 ounces 60ml rye whiskey '),
	(77,'field',11,1,' whiskey '),
	(77,'slug',0,1,''),
	(191,'extension',0,1,' jpg '),
	(191,'kind',0,1,' image '),
	(74,'slug',0,1,' old fashioned '),
	(74,'title',0,1,' old fashioned '),
	(79,'field',1,1,' sangria '),
	(79,'field',9,1,' brandy 1 2 cup brandy 1 4 cup lemon juice 1 3 cup frozen lemonade concentrate orange juice 1 3 cup orange juice red wine 1 750 milliliter bottle dry red wine triple sec 1 2 cup triple sec 1 lemon sliced into rounds 1 orange sliced into rounds 1 lime sliced into rounds 1 4 cup white sugar optional 8 maraschino cherries club soda 2 cups club soda optional '),
	(79,'field',6,1,' in a large pitcher or bowl mix together the brandy lemon juice lemonade concentrate orange juice red wine triple sec and sugar in a large pitcher or bowl mix together the brandy lemon juice lemonade concentrate orange juice red wine triple sec and sugar float slices of lemon orange and lime and maraschino cherries in the mixture float slices of lemon orange and lime and maraschino cherries in the mixture refrigerate overnight for best flavor refrigerate overnight for best flavor for a fizzy sangria add club soda just before serving for a fizzy sangria add club soda just before serving '),
	(79,'field',2,1,' sangria is an alcoholic beverage of spanish origin a punch the sangria traditionally consists of red wine and chopped fruit often with other ingredients such as orange juice or brandy '),
	(79,'field',8,1,' pitcher '),
	(80,'field',10,1,' 1 2 cup brandy '),
	(80,'field',11,1,' brandy '),
	(80,'slug',0,1,''),
	(81,'field',10,1,' 1 4 cup lemon juice '),
	(81,'field',11,1,''),
	(81,'slug',0,1,''),
	(82,'field',10,1,' 1 3 cup frozen lemonade concentrate '),
	(82,'field',11,1,''),
	(82,'slug',0,1,''),
	(83,'field',10,1,' 1 3 cup orange juice '),
	(83,'field',11,1,' orange juice '),
	(83,'slug',0,1,''),
	(84,'field',10,1,' 1 750 milliliter bottle dry red wine '),
	(84,'field',11,1,' red wine '),
	(84,'slug',0,1,''),
	(85,'field',10,1,' 1 2 cup triple sec '),
	(85,'field',11,1,' triple sec '),
	(85,'slug',0,1,''),
	(86,'field',10,1,' 1 lemon sliced into rounds '),
	(86,'field',11,1,''),
	(86,'slug',0,1,''),
	(87,'field',10,1,' 1 orange sliced into rounds '),
	(87,'field',11,1,''),
	(87,'slug',0,1,''),
	(88,'field',10,1,' 1 lime sliced into rounds '),
	(88,'field',11,1,''),
	(88,'slug',0,1,''),
	(89,'field',10,1,' 1 4 cup white sugar optional '),
	(89,'field',11,1,''),
	(89,'slug',0,1,''),
	(90,'field',10,1,' 8 maraschino cherries '),
	(90,'field',11,1,''),
	(90,'slug',0,1,''),
	(91,'field',10,1,' 2 cups club soda optional '),
	(91,'field',11,1,' club soda '),
	(91,'slug',0,1,''),
	(79,'slug',0,1,' sangria '),
	(79,'title',0,1,' sangria '),
	(92,'field',1,1,' aperol spritz '),
	(92,'field',9,1,' aperol 1 1 2 oz aperol prosecco 3 oz prosecco club soda 3 4 oz sparkling water or club soda '),
	(92,'field',6,1,' fill a white wine glass halfway with ice fill a white wine glass halfway with ice add the aperol prosecco and sparkling water and stir twice with a spoon add the aperol prosecco and sparkling water and stir twice with a spoon serve with an orange slice if desired serve with an orange slice if desired '),
	(92,'field',2,1,' an aperol spritz is an aperitif cocktail consisting of prosecco aperol and soda water '),
	(92,'field',8,1,' wine grande '),
	(93,'field',10,1,' 1 1 2 oz aperol '),
	(93,'field',11,1,' aperol '),
	(93,'slug',0,1,''),
	(94,'field',10,1,' 3 oz prosecco '),
	(94,'field',11,1,' prosecco '),
	(94,'slug',0,1,''),
	(95,'field',10,1,' 3 4 oz sparkling water or club soda '),
	(95,'field',11,1,' club soda '),
	(95,'slug',0,1,''),
	(92,'slug',0,1,' aperol spritz '),
	(92,'title',0,1,' aperol spritz '),
	(96,'filename',0,1,' martini jpg '),
	(96,'extension',0,1,' jpg '),
	(96,'kind',0,1,' image '),
	(96,'slug',0,1,''),
	(96,'title',0,1,' martini '),
	(97,'filename',0,1,' mojito jpg '),
	(97,'extension',0,1,' jpg '),
	(97,'kind',0,1,' image '),
	(97,'slug',0,1,''),
	(97,'title',0,1,' mojito '),
	(98,'field',1,1,' mojito '),
	(98,'field',9,1,' 10 fresh mint leaves 1 2 lime cut into 4 wedges 2 tablespoons white sugar or to taste 1 cup ice cubes white rum 1 1 2 fluid ounces white rum club soda 1 2 cup club soda '),
	(98,'field',6,1,' place mint leaves and 1 lime wedge into a sturdy glass place mint leaves and 1 lime wedge into a sturdy glass use a muddler to crush the mint and lime to release the mint oils and lime juice use a muddler to crush the mint and lime to release the mint oils and lime juice add 2 more lime wedges and the sugar and muddle again to release the lime juice add 2 more lime wedges and the sugar and muddle again to release the lime juice do not strain the mixture fill the glass almost to the top with ice do not strain the mixture fill the glass almost to the top with ice pour the rum over the ice and fill the glass with carbonated water pour the rum over the ice and fill the glass with carbonated water stir taste and add more sugar if desired stir taste and add more sugar if desired garnish with the remaining lime wedge garnish with the remaining lime wedge '),
	(98,'field',2,1,' mojito is a traditional cuban highball traditionally a mojito is a cocktail that consists of five ingredients white rum sugar traditionally sugar cane juice lime juice soda water and mint its combination of sweetness citrus and mint flavors is intended to complement the rum and has made the mojito a popular summer drink the cocktail has a relatively low alcohol content about 10% alcohol by volume when preparing a mojito fresh lime juice is added to sugar or to simple syrup and mint leaves the mixture is then gently mashed with a muddler the mint leaves should only be bruised to release the essential oils and should not be shredded then rum is added and the mixture is briefly stirred to dissolve the sugar and to lift the mint leaves up from the bottom for better presentation finally the drink is topped with crushed ice and sparkling soda water mint leaves and lime wedges are used to garnish the glass '),
	(98,'field',8,1,' highball '),
	(99,'field',10,1,' 10 fresh mint leaves '),
	(99,'field',11,1,''),
	(99,'slug',0,1,''),
	(100,'field',10,1,' 1 2 lime cut into 4 wedges '),
	(100,'field',11,1,''),
	(100,'slug',0,1,''),
	(101,'field',10,1,' 2 tablespoons white sugar or to taste '),
	(101,'field',11,1,''),
	(101,'slug',0,1,''),
	(102,'field',10,1,' 1 cup ice cubes '),
	(102,'field',11,1,''),
	(102,'slug',0,1,''),
	(103,'field',10,1,' 1 1 2 fluid ounces white rum '),
	(103,'field',11,1,' white rum '),
	(103,'slug',0,1,''),
	(104,'field',10,1,' 1 2 cup club soda '),
	(104,'field',11,1,' club soda '),
	(104,'slug',0,1,''),
	(98,'slug',0,1,' mojito '),
	(98,'title',0,1,' mojito '),
	(105,'field',1,1,' martini '),
	(105,'field',9,1,' gin 3 1 2 oz gin vermouth 1 2 oz dry vermouth olive or lemon twist for garnish '),
	(105,'field',6,1,' pour ice gin and vermouth into a glass shaker pour ice gin and vermouth into a glass shaker shake and pour into a martini glass shake and pour into a martini glass garnish with olives or lemon twist garnish with olives or lemon twist '),
	(105,'field',2,1,' h l mencken called the martini the only american invention as perfect as the sonnet and e b white called it the elixir of quietude '),
	(105,'field',8,1,' martini '),
	(167,'filename',0,1,' dale jpg '),
	(167,'extension',0,1,' jpg '),
	(167,'kind',0,1,' image '),
	(167,'slug',0,1,''),
	(167,'title',0,1,' dale '),
	(165,'title',0,1,' cathie '),
	(165,'slug',0,1,''),
	(105,'slug',0,1,' martini '),
	(105,'title',0,1,' gin martini '),
	(164,'email',0,1,' cathie ontherocks app '),
	(163,'slug',0,1,''),
	(162,'email',0,1,' bjorn ontherocks app '),
	(162,'slug',0,1,''),
	(163,'filename',0,1,' bjorn jpg '),
	(163,'extension',0,1,' jpg '),
	(163,'kind',0,1,' image '),
	(155,'field',10,1,' 3 1 2 oz gin '),
	(155,'field',11,1,' gin '),
	(155,'slug',0,1,''),
	(156,'field',10,1,' 1 2 oz dry vermouth '),
	(156,'field',11,1,' vermouth '),
	(156,'slug',0,1,''),
	(157,'field',10,1,' olive or lemon twist for garnish '),
	(157,'field',11,1,''),
	(157,'slug',0,1,''),
	(168,'field',7,1,' bend or '),
	(166,'slug',0,1,''),
	(166,'fullname',0,1,' dale '),
	(166,'email',0,1,' dale ontherocks app '),
	(166,'field',7,1,' bend or '),
	(166,'username',0,1,' dale '),
	(166,'firstname',0,1,' dale '),
	(166,'lastname',0,1,''),
	(168,'username',0,1,' garrett '),
	(168,'firstname',0,1,' garrett '),
	(168,'lastname',0,1,''),
	(168,'fullname',0,1,' garrett '),
	(168,'email',0,1,' garrett ontherocks app '),
	(168,'slug',0,1,''),
	(169,'filename',0,1,' garrett jpg '),
	(169,'extension',0,1,' jpg '),
	(169,'kind',0,1,' image '),
	(169,'slug',0,1,''),
	(169,'title',0,1,' dale 180922 034251 '),
	(170,'field',7,1,' bend or '),
	(170,'username',0,1,' tiff '),
	(170,'firstname',0,1,' tiff '),
	(170,'lastname',0,1,''),
	(170,'fullname',0,1,' tiff '),
	(170,'email',0,1,' tiff ontherocks app '),
	(170,'slug',0,1,''),
	(171,'filename',0,1,' tiff jpg '),
	(171,'extension',0,1,' jpg '),
	(171,'kind',0,1,' image '),
	(171,'slug',0,1,''),
	(171,'title',0,1,' tiff '),
	(172,'field',7,1,' bend or '),
	(172,'username',0,1,' tj '),
	(172,'firstname',0,1,' tj '),
	(172,'lastname',0,1,''),
	(172,'fullname',0,1,' tj '),
	(172,'email',0,1,' tj ontherocks app '),
	(172,'slug',0,1,''),
	(173,'filename',0,1,' tj jpg '),
	(173,'extension',0,1,' jpg '),
	(173,'kind',0,1,' image '),
	(173,'slug',0,1,''),
	(173,'title',0,1,' tj '),
	(174,'field',2,1,''),
	(174,'slug',0,1,' vermouth '),
	(174,'title',0,1,' vermouth '),
	(175,'slug',0,1,' white rum '),
	(175,'title',0,1,' white rum '),
	(176,'slug',0,1,' club soda '),
	(176,'title',0,1,' club soda '),
	(177,'slug',0,1,' aperol '),
	(177,'title',0,1,' aperol '),
	(178,'slug',0,1,' prosecco '),
	(178,'title',0,1,' prosecco '),
	(179,'slug',0,1,' brandy '),
	(179,'title',0,1,' brandy '),
	(180,'slug',0,1,' orange juice '),
	(180,'title',0,1,' orange juice '),
	(181,'slug',0,1,' red wine '),
	(181,'title',0,1,' red wine '),
	(182,'slug',0,1,' triple sec '),
	(182,'title',0,1,' triple sec '),
	(183,'slug',0,1,' simple syrup '),
	(183,'title',0,1,' simple syrup '),
	(184,'slug',0,1,' bitters '),
	(184,'title',0,1,' bitters '),
	(185,'slug',0,1,' champagne '),
	(185,'title',0,1,' champagne '),
	(186,'slug',0,1,' tequila '),
	(186,'title',0,1,' tequila '),
	(187,'slug',0,1,' whiskey '),
	(187,'title',0,1,' whiskey '),
	(191,'title',0,1,' veronica '),
	(191,'slug',0,1,''),
	(190,'lastname',0,1,''),
	(190,'fullname',0,1,' veronica '),
	(190,'firstname',0,1,' veronica '),
	(190,'username',0,1,' veronica ');
ALTER TABLE `searchindex` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `sections` WRITE;
ALTER TABLE `sections` DISABLE KEYS;
INSERT INTO `sections` (`id`, `structureId`, `name`, `handle`, `type`, `enableVersioning`, `propagateEntries`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,NULL,'Ingredients','ingredients','channel',0,1,'2018-09-19 07:58:44','2018-09-21 03:36:31','51c64b40-052c-4f5a-8283-9544782a7c50'),
	(2,NULL,'Recipes','recipes','channel',1,1,'2018-09-19 08:17:31','2018-09-19 08:17:31','e8178758-cf97-4d1a-a31a-aab7445a369a');
ALTER TABLE `sections` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `sections_sites` WRITE;
ALTER TABLE `sections_sites` DISABLE KEYS;
INSERT INTO `sections_sites` (`id`, `sectionId`, `siteId`, `hasUrls`, `uriFormat`, `template`, `enabledByDefault`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,1,1,0,NULL,NULL,1,'2018-09-19 07:58:44','2018-09-21 03:36:31','399dd250-aee4-4aa8-8994-9d432d18d619'),
	(2,2,1,1,'recipes/{slug}','recipes/_entry',1,'2018-09-19 08:17:31','2018-09-19 08:17:31','d8df2a3f-7b06-47e9-bf53-205a8ac355ba');
ALTER TABLE `sections_sites` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `sessions` WRITE;
ALTER TABLE `sessions` DISABLE KEYS;
ALTER TABLE `sessions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `shunnedmessages` WRITE;
ALTER TABLE `shunnedmessages` DISABLE KEYS;
ALTER TABLE `shunnedmessages` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `sitegroups` WRITE;
ALTER TABLE `sitegroups` DISABLE KEYS;
INSERT INTO `sitegroups` (`id`, `name`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'On the Rocks','2018-09-18 20:53:52','2018-09-18 20:53:52','31530e7a-934c-4998-9265-b51871157fc2');
ALTER TABLE `sitegroups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `stc_ingredients` WRITE;
ALTER TABLE `stc_ingredients` DISABLE KEYS;
INSERT INTO `stc_ingredients` (`id`, `elementId`, `siteId`, `dateCreated`, `dateUpdated`, `uid`, `field_label`) VALUES 
	(1,40,1,'2018-09-20 21:29:33','2018-09-22 03:52:56','ffba2b90-08cf-4177-9eb1-af837054a151','10 apples, quartered'),
	(2,41,1,'2018-09-20 21:29:33','2018-09-22 03:52:56','f84d85d5-016a-403a-ac01-9872c4b20700','3/4 cup white vinegar'),
	(3,42,1,'2018-09-20 21:30:01','2018-09-22 03:53:49','f20e3f0c-2dbe-4419-a04d-55aee6295241','1 part vodka'),
	(4,43,1,'2018-09-20 21:30:01','2018-09-22 03:53:49','2f2285aa-7840-4dcf-bcdc-bbde2a24222c','1 part grapefruit juice'),
	(5,44,1,'2018-09-20 21:30:25','2018-09-22 03:55:32','2acda7f2-db3f-4bb1-98f4-e80955a9ec21','1 part vodka'),
	(6,45,1,'2018-09-20 21:30:25','2018-09-22 03:55:32','c26b0d06-6815-4df1-b54b-13a643d334fe','2 parts tonic water'),
	(7,46,1,'2018-09-20 21:30:58','2018-09-24 00:17:23','72a61c1f-6727-4178-947e-9403839ae2d7','1 part gin'),
	(8,47,1,'2018-09-20 21:30:58','2018-09-24 00:17:23','7309ac83-f3d7-414c-aad6-a38982d2e611','2 parts tonic water'),
	(9,49,1,'2018-09-20 21:50:46','2018-09-22 03:52:35','ee3f8738-4ad0-4ccb-ba9b-5c7552c4e694','5 fl. oz prepared lemonade'),
	(10,50,1,'2018-09-20 21:50:46','2018-09-22 03:52:35','c36804d3-4dfa-451e-825f-6f35ede8da0c','5 fl. oz prepared iced tea'),
	(11,52,1,'2018-09-20 21:59:34','2018-09-23 23:18:55','74fbe897-2d52-4259-97e5-3a420f3162cc','1.5 fl. oz Irish cream liqueur'),
	(12,53,1,'2018-09-20 21:59:34','2018-09-23 23:18:55','79daafc3-52b1-4f3b-b6a6-293eec7c7152','1.5 fl. oz Irish whiskey'),
	(13,54,1,'2018-09-20 21:59:34','2018-09-23 23:18:55','8c6cfa3d-9a15-4e88-b069-88dbdfe04036','1 cup hot brewed coffee'),
	(14,56,1,'2018-09-20 22:05:14','2018-09-22 03:58:27','a9969727-2fe3-42ef-a7bc-7da15958cc99','1 3/4 cups white sugar'),
	(15,57,1,'2018-09-20 22:05:14','2018-09-22 03:58:27','986d66aa-b48b-49b0-9644-835d6c8de7d8','8 cups water'),
	(16,59,1,'2018-09-20 22:09:38','2018-09-22 03:50:49','1575f764-e7e1-48e3-bb7a-b89a017b61fb','2 cups frozen vodka'),
	(17,60,1,'2018-09-20 22:09:39','2018-09-22 03:50:49','d12923f4-7263-48b6-82bc-9e8d98f75fcd','1/2 cup freshly squeezed lemon juice'),
	(18,61,1,'2018-09-20 22:09:39','2018-09-22 03:50:49','bfbd5dd5-d987-4827-adc4-fe3e207c3d7a','1/2 cup superfine sugar'),
	(19,62,1,'2018-09-20 22:09:39','2018-09-22 03:50:49','e3a76228-f485-495e-b4a7-823b159a544b','1 lemon, thinly sliced'),
	(20,63,1,'2018-09-20 22:09:39','2018-09-22 03:50:49','87776a40-7183-457b-81e6-98b25f2744c3','Ice'),
	(21,65,1,'2018-09-20 22:14:46','2018-09-23 23:18:13','bab4c45f-543a-4ff2-ac75-55a99b95ec10','Ice cubes'),
	(22,66,1,'2018-09-20 22:14:46','2018-09-23 23:18:13','94140d25-a1ae-467d-9d5e-4fbb7baad4ed','3 oz tequila'),
	(23,67,1,'2018-09-20 22:14:46','2018-09-23 23:18:13','97197414-f05d-4bef-9b22-b2c9f1c681a9','2 oz freshly-squeezed lime juice'),
	(24,68,1,'2018-09-20 22:14:46','2018-09-23 23:18:13','b3d21340-b351-4436-bff1-2f72673e1482','1 oz simple syrup'),
	(25,69,1,'2018-09-20 22:14:46','2018-09-23 23:18:13','bb353cea-f199-435e-82df-d8a01d41ad7b','1/2 tsp orange liqueur'),
	(26,70,1,'2018-09-20 22:14:46','2018-09-23 23:18:13','284b749a-0e7b-42cc-ac11-dd83050ec238','1 tbsp lime-salt-sugar'),
	(27,72,1,'2018-09-20 22:18:27','2018-09-23 23:17:09','a2fe8ba8-5a07-44b2-83b1-d285c97d9052','3 parts champagne, chilled'),
	(28,73,1,'2018-09-20 22:18:27','2018-09-23 23:17:09','08a4ba6a-28cf-4c7e-99ef-3bb457f1cbaf','1 part orange juice'),
	(29,75,1,'2018-09-20 22:22:34','2018-09-24 00:17:40','1cfc6670-3f04-427e-a59b-cc9545c2fd8a','2 tsp simple syrup'),
	(30,76,1,'2018-09-20 22:22:34','2018-09-24 00:17:40','c760937c-69db-4da5-9bd1-befac25d8b6c','2 to 3 dashes bitters'),
	(31,77,1,'2018-09-20 22:22:34','2018-09-24 00:17:40','79d73234-133e-44b0-96e2-8ac218e1980d','2 ounces (60ml) rye whiskey'),
	(33,80,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','2f6eef05-708a-408f-b6dc-7d31c9576dfb','1/2 cup brandy'),
	(34,81,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','772e4250-b28e-4350-bad3-04b88b31bed6','1/4 cup lemon juice'),
	(35,82,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','c2efa670-afa3-4458-8c52-dbeb69403d58','1/3 cup frozen lemonade concentrate'),
	(36,83,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','8c945990-44a5-4ffd-82a3-3e680f04a06f','1/3 cup orange juice'),
	(37,84,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','19f85fe3-de32-43d7-b483-603732dd6ca4','1 (750 milliliter) bottle dry red wine'),
	(38,85,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','15b58dcc-f96e-448e-8b38-82bc68e7a175','1/2 cup triple sec'),
	(39,86,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','f3c95b80-4454-4301-bfc2-b424c04a046e','1 lemon, sliced into rounds'),
	(40,87,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','e625e98b-abdb-4b78-9a1a-14429ca764a8','1 orange, sliced into rounds'),
	(41,88,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','0affc4db-89a2-413a-9f4f-a5d247a7733e','1 lime, sliced into rounds'),
	(42,89,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','cf8d5865-c437-44d1-8a99-277a5b5b50a6','1/4 cup white sugar (optional)'),
	(43,90,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','26a68a51-9fa8-4c54-a8b1-296b97c813c3','8 maraschino cherries'),
	(44,91,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','1bff2867-f91a-4c85-abc6-35b880a4d5c1','2 cups club soda (optional)'),
	(45,93,1,'2018-09-20 22:30:35','2018-09-23 23:14:09','887208c3-051e-489d-b818-8540ae47e889','1 1/2 oz Aperol'),
	(46,94,1,'2018-09-20 22:30:35','2018-09-23 23:14:09','27580a58-06c0-4530-924d-54323a62c0e7','3 oz prosecco'),
	(47,95,1,'2018-09-20 22:30:35','2018-09-23 23:14:09','32a028b2-3641-429f-bd5e-6479488fd81e','3/4 oz sparkling water or club soda'),
	(48,99,1,'2018-09-20 23:50:50','2018-09-23 23:13:14','b68fe2d8-ac4f-4b69-b8d7-ed239b9518f3','10 fresh mint leaves'),
	(49,100,1,'2018-09-20 23:50:50','2018-09-23 23:13:14','8a529746-9f81-49fd-a453-bfbfbdfb57ea','1/2 lime, cut into 4 wedges'),
	(50,101,1,'2018-09-20 23:50:50','2018-09-23 23:13:14','c35363ea-d1c2-4d60-8409-93bcdecdf222','2 tablespoons white sugar, or to taste'),
	(51,102,1,'2018-09-20 23:50:50','2018-09-23 23:13:14','8dd4eaeb-a941-4d8a-98ea-20dfcf69d708','1 cup ice cubes'),
	(52,103,1,'2018-09-20 23:50:50','2018-09-23 23:13:14','41ce4664-b9c5-4098-8424-7184c78b13fc','1 1/2 fluid ounces white rum'),
	(53,104,1,'2018-09-20 23:50:50','2018-09-23 23:13:14','b202b263-a557-4d5d-bc05-770d509e3287','1/2 cup club soda'),
	(99,155,1,'2018-09-21 17:07:51','2018-09-24 00:17:33','fce04c46-3d28-434b-8715-5480817dcb0c','3 1/2 oz gin'),
	(100,156,1,'2018-09-21 17:07:51','2018-09-24 00:17:33','11aecd7f-dcc2-450d-906f-0d6f402b5464','1/2 oz dry vermouth'),
	(101,157,1,'2018-09-21 17:07:51','2018-09-24 00:17:33','3aafed10-2ea2-4ffb-a50f-a2649d3fa332','Olive or lemon twist for garnish');
ALTER TABLE `stc_ingredients` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `structures` WRITE;
ALTER TABLE `structures` DISABLE KEYS;
ALTER TABLE `structures` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `structureelements` WRITE;
ALTER TABLE `structureelements` DISABLE KEYS;
ALTER TABLE `structureelements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `supertableblocktypes` WRITE;
ALTER TABLE `supertableblocktypes` DISABLE KEYS;
INSERT INTO `supertableblocktypes` (`id`, `fieldId`, `fieldLayoutId`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,9,7,'2018-09-20 21:28:09','2018-09-20 21:28:09','f9e9f58b-ef66-4c21-a818-0dfafec5f40f');
ALTER TABLE `supertableblocktypes` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `supertableblocks` WRITE;
ALTER TABLE `supertableblocks` DISABLE KEYS;
INSERT INTO `supertableblocks` (`id`, `ownerId`, `ownerSiteId`, `fieldId`, `typeId`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(40,37,NULL,9,1,1,'2018-09-20 21:29:33','2018-09-22 03:52:56','7df74031-1b32-4c76-ac29-3011d5db0703'),
	(41,37,NULL,9,1,2,'2018-09-20 21:29:33','2018-09-22 03:52:56','be79fd3d-7515-416b-bb55-a7050a854418'),
	(42,17,NULL,9,1,1,'2018-09-20 21:30:01','2018-09-22 03:53:49','1e67a817-3280-420b-a14f-389135f6d301'),
	(43,17,NULL,9,1,2,'2018-09-20 21:30:01','2018-09-22 03:53:49','0b0a5d1e-d04d-4dbe-9e5f-e85dc4c397aa'),
	(44,13,NULL,9,1,1,'2018-09-20 21:30:25','2018-09-22 03:55:32','6ae4690f-b5b5-4819-b5b9-0815531640b7'),
	(45,13,NULL,9,1,2,'2018-09-20 21:30:25','2018-09-22 03:55:32','53d7e330-b407-4d37-8679-b8af4395703d'),
	(46,9,NULL,9,1,1,'2018-09-20 21:30:58','2018-09-24 00:17:23','40feb2d8-a52b-40a7-b58c-0b223468efc9'),
	(47,9,NULL,9,1,2,'2018-09-20 21:30:58','2018-09-24 00:17:23','f3fb8f86-060f-44bb-abe0-f7e680c34ea6'),
	(49,48,NULL,9,1,1,'2018-09-20 21:50:46','2018-09-22 03:52:35','0796300f-be55-4817-85dc-3d242b558abd'),
	(50,48,NULL,9,1,2,'2018-09-20 21:50:46','2018-09-22 03:52:35','14ae7044-3fea-488a-8745-2e72aa121e51'),
	(52,51,NULL,9,1,1,'2018-09-20 21:59:34','2018-09-23 23:18:55','1eff8923-9869-475a-af5f-1254c41f73a7'),
	(53,51,NULL,9,1,2,'2018-09-20 21:59:34','2018-09-23 23:18:55','3621d84b-7c46-49e1-87c1-ea179d2c9deb'),
	(54,51,NULL,9,1,3,'2018-09-20 21:59:34','2018-09-23 23:18:55','5fb28519-cb75-4c77-882c-9bcf5849d27f'),
	(56,55,NULL,9,1,1,'2018-09-20 22:05:14','2018-09-22 03:58:27','229642d8-4ef9-49f8-b68c-d36b099ba50f'),
	(57,55,NULL,9,1,2,'2018-09-20 22:05:14','2018-09-22 03:58:27','765c08e6-9a6d-44d7-bb0e-35cc839ee635'),
	(59,58,NULL,9,1,1,'2018-09-20 22:09:39','2018-09-22 03:50:49','144678ed-aa26-437e-9171-a97d571d20a6'),
	(60,58,NULL,9,1,2,'2018-09-20 22:09:39','2018-09-22 03:50:49','61fc2f6c-f935-4249-8064-8e3272e732d7'),
	(61,58,NULL,9,1,3,'2018-09-20 22:09:39','2018-09-22 03:50:49','d30c9506-b7c7-43d0-b2c8-88778f955a05'),
	(62,58,NULL,9,1,4,'2018-09-20 22:09:39','2018-09-22 03:50:49','aa5b57d8-27cd-4c89-bdba-0ea53c001d89'),
	(63,58,NULL,9,1,5,'2018-09-20 22:09:39','2018-09-22 03:50:49','fb6017b6-1d43-4476-92ac-536caac9c56d'),
	(65,64,NULL,9,1,1,'2018-09-20 22:14:46','2018-09-23 23:18:13','01c18aa3-e505-4e31-9e38-83e9600f4eb0'),
	(66,64,NULL,9,1,2,'2018-09-20 22:14:46','2018-09-23 23:18:13','83f85978-0205-4cb3-b8be-fc72c34f6585'),
	(67,64,NULL,9,1,3,'2018-09-20 22:14:46','2018-09-23 23:18:13','82995609-2689-4984-b5f0-92b34a263fb4'),
	(68,64,NULL,9,1,4,'2018-09-20 22:14:46','2018-09-23 23:18:13','bb85e04c-b090-487c-9188-96cfcca54fb2'),
	(69,64,NULL,9,1,5,'2018-09-20 22:14:46','2018-09-23 23:18:13','4530e596-14ac-4852-8fe6-7f216b6f3e6e'),
	(70,64,NULL,9,1,6,'2018-09-20 22:14:46','2018-09-23 23:18:13','7396c060-fbe5-437c-bb57-93021cf20e11'),
	(72,71,NULL,9,1,1,'2018-09-20 22:18:27','2018-09-23 23:17:09','27dd4702-c2b0-4ef0-9247-3f09cb19d7ae'),
	(73,71,NULL,9,1,2,'2018-09-20 22:18:27','2018-09-23 23:17:09','3b78f26f-5761-406d-bba8-635b98f97cd2'),
	(75,74,NULL,9,1,1,'2018-09-20 22:22:34','2018-09-24 00:17:40','f5f71ba7-c368-49c4-9d83-3222cd55970b'),
	(76,74,NULL,9,1,2,'2018-09-20 22:22:34','2018-09-24 00:17:40','fa546f5f-9699-4e47-8072-dd34f41abc40'),
	(77,74,NULL,9,1,3,'2018-09-20 22:22:34','2018-09-24 00:17:40','9cdb7850-8e10-4d39-8221-c926a8efad54'),
	(80,79,NULL,9,1,1,'2018-09-20 22:27:18','2018-09-23 23:16:19','27ebb33d-4cae-4053-919c-308fdeede244'),
	(81,79,NULL,9,1,2,'2018-09-20 22:27:18','2018-09-23 23:16:19','8f4c3023-a346-4589-90e6-25a7db33b6ae'),
	(82,79,NULL,9,1,3,'2018-09-20 22:27:18','2018-09-23 23:16:19','eb3ba4eb-30dc-4b82-8b75-cc1e9740fd87'),
	(83,79,NULL,9,1,4,'2018-09-20 22:27:18','2018-09-23 23:16:19','40f6148f-d611-48e9-95f7-e28dc8ca23c4'),
	(84,79,NULL,9,1,5,'2018-09-20 22:27:18','2018-09-23 23:16:19','f7d591a3-ccc1-4be5-b504-34ca080e34af'),
	(85,79,NULL,9,1,6,'2018-09-20 22:27:18','2018-09-23 23:16:19','05747c75-2989-4ed5-93b3-671539e0ba03'),
	(86,79,NULL,9,1,7,'2018-09-20 22:27:18','2018-09-23 23:16:19','2e61aca0-7aa3-4b7f-8965-304fa541d6ba'),
	(87,79,NULL,9,1,8,'2018-09-20 22:27:18','2018-09-23 23:16:19','a4d63829-fd5b-46c8-882c-0f85fc412d65'),
	(88,79,NULL,9,1,9,'2018-09-20 22:27:18','2018-09-23 23:16:19','0a9908b5-9a90-46d4-ad28-eb726506771b'),
	(89,79,NULL,9,1,10,'2018-09-20 22:27:18','2018-09-23 23:16:19','6db096c1-9bd4-4d60-96e9-b97ce98c9a5e'),
	(90,79,NULL,9,1,11,'2018-09-20 22:27:18','2018-09-23 23:16:19','1b12332a-6278-4157-909b-565216bfd5b6'),
	(91,79,NULL,9,1,12,'2018-09-20 22:27:18','2018-09-23 23:16:19','f1e3fcb9-b14d-4a6e-b871-bf3b7051ce9c'),
	(93,92,NULL,9,1,1,'2018-09-20 22:30:35','2018-09-23 23:14:09','208038e9-0445-43fd-a50e-4c086db6133d'),
	(94,92,NULL,9,1,2,'2018-09-20 22:30:35','2018-09-23 23:14:09','0859158e-b839-4db8-b470-51025bc69bf1'),
	(95,92,NULL,9,1,3,'2018-09-20 22:30:35','2018-09-23 23:14:09','30a5f0e0-4df1-4d91-8f3f-382e0b143673'),
	(99,98,NULL,9,1,1,'2018-09-20 23:50:50','2018-09-23 23:13:14','3d5c404b-fc26-4a86-84ae-07f33e757166'),
	(100,98,NULL,9,1,2,'2018-09-20 23:50:50','2018-09-23 23:13:14','3a71906b-b8d4-497c-bf15-ff384c060cf2'),
	(101,98,NULL,9,1,3,'2018-09-20 23:50:50','2018-09-23 23:13:14','3631494c-c689-46ce-ae8f-139aaa6956bb'),
	(102,98,NULL,9,1,4,'2018-09-20 23:50:50','2018-09-23 23:13:14','e386909d-cf65-47a6-8f78-d6935ba4ae86'),
	(103,98,NULL,9,1,5,'2018-09-20 23:50:50','2018-09-23 23:13:14','53c10100-1b1a-4b8c-bca0-31a6f7457841'),
	(104,98,NULL,9,1,6,'2018-09-20 23:50:50','2018-09-23 23:13:14','a30ee564-a1d2-43c6-bc24-19bb5dec9539'),
	(155,105,NULL,9,1,1,'2018-09-21 17:07:51','2018-09-24 00:17:33','fc4644ed-986e-4a37-a1a6-9e92731dd405'),
	(156,105,NULL,9,1,2,'2018-09-21 17:07:51','2018-09-24 00:17:33','666d81be-faf9-430e-930b-4fa0857a66e3'),
	(157,105,NULL,9,1,3,'2018-09-21 17:07:51','2018-09-24 00:17:33','db73ba88-6f3f-4ea5-a6f3-a017d5e0ee12');
ALTER TABLE `supertableblocks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `systemmessages` WRITE;
ALTER TABLE `systemmessages` DISABLE KEYS;
ALTER TABLE `systemmessages` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `systemsettings` WRITE;
ALTER TABLE `systemsettings` DISABLE KEYS;
INSERT INTO `systemsettings` (`id`, `category`, `settings`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'email','{"fromEmail":"admin@ontherocks.app","fromName":"On the Rocks","transportType":"craft\\\\mail\\\\transportadapters\\\\Sendmail"}','2018-09-18 20:53:53','2018-09-18 20:53:53','edf168fb-f8d4-48f8-aab2-bbe622757439'),
	(2,'users','{"requireEmailVerification":false,"allowPublicRegistration":true,"defaultGroup":"1","photoVolumeId":"1","photoSubpath":""}','2018-09-18 23:44:17','2018-09-21 09:40:41','4d196f7d-88ab-4c9e-9aa3-d8c938324f0f');
ALTER TABLE `systemsettings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `taggroups` WRITE;
ALTER TABLE `taggroups` DISABLE KEYS;
ALTER TABLE `taggroups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `tags` WRITE;
ALTER TABLE `tags` DISABLE KEYS;
ALTER TABLE `tags` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `templatecaches` WRITE;
ALTER TABLE `templatecaches` DISABLE KEYS;
ALTER TABLE `templatecaches` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `templatecacheelements` WRITE;
ALTER TABLE `templatecacheelements` DISABLE KEYS;
ALTER TABLE `templatecacheelements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `templatecachequeries` WRITE;
ALTER TABLE `templatecachequeries` DISABLE KEYS;
ALTER TABLE `templatecachequeries` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `tokens` WRITE;
ALTER TABLE `tokens` DISABLE KEYS;
ALTER TABLE `tokens` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `usergroups` WRITE;
ALTER TABLE `usergroups` DISABLE KEYS;
INSERT INTO `usergroups` (`id`, `name`, `handle`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'Members','members','2018-09-21 09:40:34','2018-09-21 09:40:34','7067ed51-30bf-491c-807a-e5f69034e60f'),
	(2,'Editors','editors','2018-09-22 03:38:53','2018-09-22 03:38:53','c8db8b57-b406-42d7-ba17-76ad6db7f790');
ALTER TABLE `usergroups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `usergroups_users` WRITE;
ALTER TABLE `usergroups_users` DISABLE KEYS;
INSERT INTO `usergroups_users` (`id`, `groupId`, `userId`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(7,2,166,'2018-09-22 03:41:51','2018-09-22 03:41:51','62604079-0a7d-4c60-a1ec-aa2c8ed758ca'),
	(17,2,164,'2018-09-22 03:44:52','2018-09-22 03:44:52','3210c2fa-b92f-4cca-b3b6-a1c354fedf3f'),
	(18,2,168,'2018-09-22 03:44:56','2018-09-22 03:44:56','54753fb8-908a-4d17-adec-bad6f8e4ad70'),
	(19,2,170,'2018-09-22 03:45:00','2018-09-22 03:45:00','18f655a2-55b1-453c-ba5e-617af6f9035f'),
	(20,2,172,'2018-09-22 03:45:06','2018-09-22 03:45:06','e51bbea8-9ddd-4311-bcdb-bcfa48cdbaa5'),
	(26,2,190,'2018-09-24 00:15:11','2018-09-24 00:15:11','6a3f8cf1-8f93-4201-8a68-efd0ce53b55c'),
	(28,2,162,'2018-09-24 00:16:17','2018-09-24 00:16:17','f39e847f-86c0-4110-815a-fe9ddd9e7bfe');
ALTER TABLE `usergroups_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `userpermissions` WRITE;
ALTER TABLE `userpermissions` DISABLE KEYS;
INSERT INTO `userpermissions` (`id`, `name`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'accesssitewhensystemisoff','2018-09-22 03:38:53','2018-09-22 03:38:53','4c5a65a3-e0c3-4084-b777-aa55fd7881e1'),
	(2,'accesscpwhensystemisoff','2018-09-22 03:38:53','2018-09-22 03:38:53','ac06e3cf-2bad-4423-b5e4-909651512375'),
	(3,'accesscp','2018-09-22 03:38:53','2018-09-22 03:38:53','03b77739-3514-4f26-80c9-420db6188ca3'),
	(4,'createentries:1','2018-09-22 03:38:53','2018-09-22 03:38:53','50a6ce67-f209-4fef-abb5-772aff5b2019'),
	(5,'publishentries:1','2018-09-22 03:38:53','2018-09-22 03:38:53','c4b1c749-8d02-4769-af0e-0ddeb70a280f'),
	(6,'deleteentries:1','2018-09-22 03:38:53','2018-09-22 03:38:53','4a605d5d-2493-474b-8a5d-2836aef294cd'),
	(7,'publishpeerentries:1','2018-09-22 03:38:53','2018-09-22 03:38:53','fad27b2d-5704-49ca-82e3-647b2eb85d9b'),
	(8,'deletepeerentries:1','2018-09-22 03:38:53','2018-09-22 03:38:53','a6b331f3-693f-4483-8280-67a2fedf372d'),
	(9,'editpeerentries:1','2018-09-22 03:38:53','2018-09-22 03:38:53','a8d9000c-2bda-4737-ac92-e4baa67a576a'),
	(10,'publishpeerentrydrafts:1','2018-09-22 03:38:53','2018-09-22 03:38:53','38ca7366-0821-4c0a-9adb-aeb251dc5c5c'),
	(11,'deletepeerentrydrafts:1','2018-09-22 03:38:53','2018-09-22 03:38:53','71cd165a-b15e-4317-b317-df866cd78059'),
	(12,'editpeerentrydrafts:1','2018-09-22 03:38:53','2018-09-22 03:38:53','91f2658d-d99b-4157-83cf-8dc1c67b0aaf'),
	(13,'editentries:1','2018-09-22 03:38:53','2018-09-22 03:38:53','7607d06e-4659-454d-a8be-227e4906c8b5'),
	(14,'createentries:2','2018-09-22 03:38:53','2018-09-22 03:38:53','6092e6d4-da10-4996-8ab4-1eaeed3d12b3'),
	(15,'publishentries:2','2018-09-22 03:38:53','2018-09-22 03:38:53','c5f620cb-4865-409b-808f-5d52486c018f'),
	(16,'deleteentries:2','2018-09-22 03:38:53','2018-09-22 03:38:53','f9f63422-dc83-452c-8edc-449ef5208a01'),
	(17,'publishpeerentries:2','2018-09-22 03:38:53','2018-09-22 03:38:53','555b9b03-979e-452f-8b1f-6b0dd938e352'),
	(18,'deletepeerentries:2','2018-09-22 03:38:53','2018-09-22 03:38:53','0a41373c-3682-4fd6-926f-800e19f1904b'),
	(19,'editpeerentries:2','2018-09-22 03:38:53','2018-09-22 03:38:53','aa455bc1-5768-4b04-9d7b-a9a7f4da75df'),
	(20,'publishpeerentrydrafts:2','2018-09-22 03:38:53','2018-09-22 03:38:53','b52f4d29-8dad-4c70-990f-8f715bafd6e5'),
	(21,'deletepeerentrydrafts:2','2018-09-22 03:38:53','2018-09-22 03:38:53','e4b1aa07-0dfc-4620-8118-89015940399e'),
	(22,'editpeerentrydrafts:2','2018-09-22 03:38:53','2018-09-22 03:38:53','9073b9e2-e120-4736-bce7-9026d93dc7da'),
	(23,'editentries:2','2018-09-22 03:38:53','2018-09-22 03:38:53','53098c4a-3ff4-454a-9695-49d3e3d8592c'),
	(24,'saveassetinvolume:2','2018-09-22 03:38:53','2018-09-22 03:38:53','bb7cfacb-9690-4db6-a23a-c03a234bf7a6'),
	(25,'createfoldersinvolume:2','2018-09-22 03:38:53','2018-09-22 03:38:53','63649d0a-ca46-4aa2-9e84-363caf19db8d'),
	(26,'deletefilesandfoldersinvolume:2','2018-09-22 03:38:53','2018-09-22 03:38:53','d9ab4b00-5af2-47c4-905b-c14ab3ef1424'),
	(27,'viewvolume:2','2018-09-22 03:38:53','2018-09-22 03:38:53','6a1c60be-9991-4af4-84f6-03322b1fe2db');
ALTER TABLE `userpermissions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `userpermissions_usergroups` WRITE;
ALTER TABLE `userpermissions_usergroups` DISABLE KEYS;
INSERT INTO `userpermissions_usergroups` (`id`, `permissionId`, `groupId`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,1,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','d8e8937d-033d-4375-bbbf-c7c4be339198'),
	(2,2,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','eb01ebcc-0b06-4f4f-b57b-b83f84c17e93'),
	(3,3,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','9612ea0d-bbbd-4650-875f-3f2bd42fab60'),
	(4,4,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','deafed5c-363b-4757-a16c-2db85f58655b'),
	(5,5,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','8ae42e62-6117-4cc8-94e6-5c818cc9ec8f'),
	(6,6,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','4b657dd3-4a03-4712-98dd-578a4494490e'),
	(7,7,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','64a00737-01fc-4e29-8fbb-b7a624ecdd0d'),
	(8,8,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','f15c0bb3-55d1-440c-a7fc-25097443d38b'),
	(9,9,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','cf149f6b-8513-423e-9c45-39f3eaae3395'),
	(10,10,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','d90da40b-086c-4f0b-838d-5b036cb2bb00'),
	(11,11,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','27da79ea-0257-4ab6-b237-46986fe1271b'),
	(12,12,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','34edf738-2f6b-4171-ad8f-78b41d947d96'),
	(13,13,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','f0b6aaee-183c-40bc-b973-c92f154a27dd'),
	(14,14,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','8d844b11-26cf-4c06-9108-e55de81c85ed'),
	(15,15,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','e7a31d13-535f-4c96-a489-17f5c6fa0656'),
	(16,16,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','15973e18-7fd2-49be-adec-74014c16b955'),
	(17,17,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','2f671c0d-3a4c-448d-8526-3b76fa7bfe7a'),
	(18,18,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','d6329ab1-0bd0-43a5-831e-4991f02a45ad'),
	(19,19,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','fde93c3f-cdf4-4f9b-a775-138e845885c3'),
	(20,20,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','858c5a25-6385-480d-8450-6d4040fa69a5'),
	(21,21,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','1c65bf8c-873b-4ca0-a103-0c31f5e26ab7'),
	(22,22,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','d0968abe-575f-4581-946a-a48b76a024f4'),
	(23,23,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','4f2e5d6f-0c0a-4a00-abe9-299223e73a14'),
	(24,24,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','26f905ce-7637-424b-b7b8-9ee4d03be83c'),
	(25,25,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','38b4a45a-177b-498c-b62b-8ff3635969c5'),
	(26,26,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','e81b6781-4818-4222-b5d9-00943970cfff'),
	(27,27,2,'2018-09-22 03:38:53','2018-09-22 03:38:53','18e46bc9-c7cf-410e-a7d0-7fd3c9f7e32e');
ALTER TABLE `userpermissions_usergroups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `users` WRITE;
ALTER TABLE `users` DISABLE KEYS;
INSERT INTO `users` (`id`, `username`, `photoId`, `firstName`, `lastName`, `email`, `password`, `admin`, `locked`, `suspended`, `pending`, `lastLoginDate`, `lastLoginAttemptIp`, `invalidLoginWindowStart`, `invalidLoginCount`, `lastInvalidLoginDate`, `lockoutDate`, `hasDashboard`, `verificationCode`, `verificationCodeIssuedDate`, `unverifiedEmail`, `passwordResetRequired`, `lastPasswordChangeDate`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'admin',NULL,'','','admin@ontherocks.app','$2y$13$4rctoyPSV0fbKm2x3XcbK.4Ir.mVpD4IgNnglS6AEViatLbDsnXSS',1,0,0,0,'2018-09-23 23:20:21','192.168.10.1',NULL,NULL,'2018-09-21 08:56:37',NULL,1,NULL,NULL,NULL,0,'2018-09-19 10:05:40','2018-09-18 20:53:53','2018-09-24 00:18:39','8add50b5-a064-4692-84bd-0aa1b471c483'),
	(162,'bjorn',163,'Bjorn','','bjorn@ontherocks.app',NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,NULL,'2018-09-22 03:40:35','2018-09-24 00:16:17','caf1b3a2-a58f-42e2-9e27-8d3433533798'),
	(164,'cathie',165,'Cathie','','cathie@ontherocks.app',NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,NULL,'2018-09-22 03:41:04','2018-09-22 03:44:52','9dce771e-df8a-41f6-9e15-ee2b6ed4d286'),
	(166,'dale',167,'Dale','','dale@ontherocks.app',NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,NULL,'2018-09-22 03:41:34','2018-09-22 03:41:51','35fe7fc2-cca7-4505-90e4-27dac4a05b14'),
	(168,'garrett',169,'Garrett','','garrett@ontherocks.app',NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,NULL,'2018-09-22 03:42:35','2018-09-22 03:44:56','22654628-074e-4ad3-a5be-4065e37e5263'),
	(170,'tiff',171,'Tiff','','tiff@ontherocks.app',NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,NULL,'2018-09-22 03:43:35','2018-09-22 03:56:18','12568e67-4a62-44e9-958c-cb1d9b043427'),
	(172,'tj',173,'TJ','','tj@ontherocks.app',NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,NULL,'2018-09-22 03:44:13','2018-09-22 03:45:06','8064313c-ab67-4c68-b8d7-5c036f1500a8'),
	(190,'veronica',191,'Veronica','','veronica@ontherocks.app',NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,NULL,'2018-09-24 00:15:03','2018-09-24 00:15:11','b0be3647-a7a4-4b9d-8257-19d6ed21d524');
ALTER TABLE `users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `userpermissions_users` WRITE;
ALTER TABLE `userpermissions_users` DISABLE KEYS;
ALTER TABLE `userpermissions_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `userpreferences` WRITE;
ALTER TABLE `userpreferences` DISABLE KEYS;
INSERT INTO `userpreferences` (`userId`, `preferences`) VALUES 
	(1,'{"language":"en","weekStartDay":"1","enableDebugToolbarForSite":false,"enableDebugToolbarForCp":false}'),
	(162,'{"language":null,"weekStartDay":null}'),
	(164,'{"language":null,"weekStartDay":null}'),
	(166,'{"language":null,"weekStartDay":null}'),
	(168,'{"language":null,"weekStartDay":null}'),
	(170,'{"language":null,"weekStartDay":null}'),
	(172,'{"language":null,"weekStartDay":null}'),
	(190,'{"language":null,"weekStartDay":null}');
ALTER TABLE `userpreferences` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `volumes` WRITE;
ALTER TABLE `volumes` DISABLE KEYS;
INSERT INTO `volumes` (`id`, `fieldLayoutId`, `name`, `handle`, `type`, `hasUrls`, `url`, `settings`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,1,'User Photos','userPhotos','craft\\volumes\\Local',1,'@web/images/users','{"path":"@webroot/images/users"}',1,'2018-09-18 23:44:05','2018-09-18 23:44:05','d38b5e07-d281-487c-9a5b-d00f303894be'),
	(2,3,'Content Photos','contentPhotos','craft\\volumes\\Local',1,'@web/images/content','{"path":"@webroot/images/content"}',2,'2018-09-19 08:00:14','2018-09-19 08:00:14','2d117110-ee42-4fef-91b2-b4c6f4296a91');
ALTER TABLE `volumes` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `volumefolders` WRITE;
ALTER TABLE `volumefolders` DISABLE KEYS;
INSERT INTO `volumefolders` (`id`, `parentId`, `volumeId`, `name`, `path`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,NULL,1,'User Photos','','2018-09-18 23:44:05','2018-09-18 23:44:05','624ac2e5-88ce-454b-bc59-f0c636cef65d'),
	(2,NULL,NULL,'Temporary source',NULL,'2018-09-19 07:58:29','2018-09-19 07:58:29','e242d05e-07f9-43d9-895f-f84faf47c849'),
	(3,2,NULL,'user_1','user_1/','2018-09-19 07:58:29','2018-09-19 07:58:29','7549507e-259d-4aac-98da-b09156921715'),
	(4,NULL,2,'Content Photos','','2018-09-19 08:00:14','2018-09-19 08:00:14','e601a4c8-f06d-418a-b38e-a6641f265274');
ALTER TABLE `volumefolders` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `widgets` WRITE;
ALTER TABLE `widgets` DISABLE KEYS;
INSERT INTO `widgets` (`id`, `userId`, `type`, `sortOrder`, `colspan`, `settings`, `enabled`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,1,'craft\\widgets\\RecentEntries',1,0,'{"section":"2","siteId":"1","limit":"10"}',1,'2018-09-18 23:35:46','2018-09-24 00:19:21','08835a1f-2fea-4b5d-8d95-0b37e83fa33b'),
	(2,1,'craft\\widgets\\CraftSupport',2,0,'[]',1,'2018-09-18 23:35:46','2018-09-18 23:35:46','98f11623-20a3-410e-b27b-06a53dae50c8'),
	(3,1,'craft\\widgets\\Updates',3,0,'[]',1,'2018-09-18 23:35:46','2018-09-18 23:35:46','795b3a19-59e7-4fd3-8f59-b52a4f84049f'),
	(4,1,'craft\\widgets\\Feed',4,0,'{"url":"https://craftcms.com/news.rss","title":"Craft News","limit":5}',1,'2018-09-18 23:35:46','2018-09-18 23:35:46','ebf2d6d3-3830-467b-b27f-f1a702e7e04f');
ALTER TABLE `widgets` ENABLE KEYS;
UNLOCK TABLES;




SET FOREIGN_KEY_CHECKS = @PREVIOUS_FOREIGN_KEY_CHECKS;


