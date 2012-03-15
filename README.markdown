# pazpar2 configuration files for SUB Göttingen

This repository contains configuration files for Indexdata’s [pazpar2](http://www.indexdata.com/pazpar2/) metasearch daemon.

## Notes
* The files »pazpar2-SUB.cfg« and »pazpar2-test.cfg« are configuration files pazpar2.
* The folder »settings« contains settings for various Z39.50, SRU and Solr data targets.
	* Not all of them are used. Those which are not used should be in »testing« subfolders and may be experimental and incomplete.
* The folder »xsl« contains XSLTs to normalise the loaded data. These are used by the files in »settings«.
* The folder »services« configures services provided by pazpar2 using the various settings files.
* Index Data’s [pazpar2](http://git.indexdata.com/?p=pazpar2.git) and [yaz](http://git.indexdata.com/?p=yaz.git) git repositories are included as a submodule in the folders »pazpar2« and »yaz«.
* The [subrepository in »pazpar2-etc«](https://github.com/ssp/pazpar2-etc) contains customised files (e.g. tmarc.xsl) from the pazpar2/etc folder. These are kept in a separate repository to enable using a cleanly checked out version of the software.
* The folder »init.d« contains the init script to automatically start pazpar2 on SuSE Linux.
* The folder »logrotate« contains a logrotate configuration and crontab entry.


## Contact
In case you have questions, please [get in touch with Sven-S. Porst](mailto:porst@sub.uni-goettingen.de?subject=pazpar2).

