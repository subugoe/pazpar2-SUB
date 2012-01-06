<?xml version="1.0" encoding="UTF-8"?>
<!--
	Deletes 'medium' pz:metadata fields and
	converts 'medium-override' pz:metadata fields to type 'medium'.
	
	Postprocessing with this stylesheet lets us override the media type
	determined by tmarc.xsl by a different mediatype we took from the 
	(typically incorrect) Marc record by writing the value we want to the
	'medium-override' pz:metadata field in preprocessing.
	
	January 2012
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pz="http://www.indexdata.com/pazpar2/1.0">
	
	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
	
	<!-- Copy all remaining nodes. -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	
	<!-- Delete any pz:metadata nodes of type 'medium'. -->
	<xsl:template match="pz:metadata[@type='medium']"/>
	
	
	<!-- Convert pz:metadata nodes of type 'medium-override' to type 'medium'. -->
	<xsl:template match="pz:metadata[@type='medium-override']">
		<pz:metadata type="medium">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

</xsl:stylesheet>
