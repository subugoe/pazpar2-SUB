# pazpar2 configuration files for SUB Göttingen

This repository contains the configuration files for Index Data’s [pazpar2](http://www.indexdata.com/pazpar2/) metasearch daemon for use at [SUB Göttingen](http://www.sub.uni-goettingen.de). 


## Contents
* »pazpar2-SUB.xml« and »pazpar2-test.xml« are main configuration files for pazpar2.
* The folder »services« configures services provided by pazpar2 using the various settings files.
	* It also contains the file »metadata.xml« with metadata settings shared by various services.
	* The subfolder »testing« contains experimental, deprecated or unused services.
* The folder »settings« contains settings for various Z39.50, SRU and Solr targets.
	* The subfolder »testing« contains experimental, deprescated or unused settings.
* The folder »xsl« contains XSLTs to normalise the loaded data. These are used by the files in »settings«.
	* It contains the stylesheet »xsl/pazpar2-docs.xsl« which converts pazpar2 XML configuration files to HTML pages.
* Git submodules with Index Data’s software:
	* »[pazpar2](https://github.com/subugoe/pazpar2-SUB)« (forked)
	* »[yaz](http://git.indexdata.com/?p=yaz.git)«
* The [subrepository in »pazpar2-etc«](https://github.com/subugoe/pazpar2-etc) contains customised files (e.g. »tmarc.xsl«) from the pazpar2/etc folder. These are kept in a separate repository to enable using a cleanly checked out version of the software.
* The folder »setup« contains configuration files to help installing the pazpar2 service on a server:
	* »pazpar2.init«: init script for SUSE Linux
	* »pazpar2.logrotate«: logrotate configuration file
	* »pazpar2-vhost.conf«: apache virtual host configuration

## Contact
In case you have questions, please [get in touch with Sven-S. Porst](mailto:porst@sub.uni-goettingen.de?subject=pazpar2).

