# pazpar2 configuration files for SUB Göttingen

This repository contains configuration files for Indexdata’s [pazpar2](http://www.indexdata.com/pazpar2/) metasearch daemon.

## Notes
* The folder »settings« contains settings for various Z39.50, SRU and Solr data targets.
	* Not all of them are used. Those which aren’t used may be experimental and incomplete.
* The folder »xsl« contains XSLTs to normalise the loaded data. These are used by the files in »settings«.
* The folder »services« configures services provided by pazpar2 using the various settings files.
* Indexdata’s [pazpar2 git repository](http://git.indexdata.com/?p=pazpar2.git;a=summary) is included as a submodule. The settings files rely on this to use the XSLT files included with pazpar2.
* We are using our own [»ssp« branch](https://github.com/ssp/pazpar2/tree/ssp) of the pazpar2 repository which has a slightly refined »tmarc.xsl«.

## Contact
In case you have questions, [get in touch with Sven-S. Porst](mailto:porst@sub.uni-goettingen.de?subject=pazpar2).

