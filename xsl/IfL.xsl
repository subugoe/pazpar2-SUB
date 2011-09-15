<?xml version="1.0" encoding="UTF-8"?>
<!--
	Fixes problems with the IfL Marc format and maps the 856 field to
	the catalogue-url metadata.
	
	September 2011
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:tmarc="http://www.indexdata.com/turbomarc"
	xmlns:pz="http://www.indexdata.com/pazpar2/1.0">
	
	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
	
	<!--
		Copy all remaining nodes.
	-->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	
	<!--
		Delete the Marc 245, 260, 300, 490 and 856 fields which are
		processed and rewritten inside the tmarc:r template.
	-->
	<xsl:template match="tmarc:d245|tmarc:d260|tmarc:d300|tmarc:d490|tmarc:d856"/>	
	
	
	<!--
		Match the Turbomarc record element and process its content.
	-->
	<xsl:template match="tmarc:r">
		<tmarc:r>
			<!-- 
				The data from this server is broken in that it doesn’t seem to
				to understand the concept of subfields and creates a new datafield
				for each subfield that occurs. Not only does this create an invalid
				Marc record (for non-repeatable fields as 245), it also breaks the
				display processing in situation where the grouping of the subfields
				is important.
				
				As a hackish fix it seems helpful to just 'merge' the subfields of
				the most affected fields into a single one.
			-->
			<xsl:if test="tmarc:d245">
				<tmarc:d245 i1=" " i2=" ">
					<xsl:for-each select="tmarc:d245/node()">
						<xsl:copy>
							<xsl:apply-templates select="@*|node()"/>
						</xsl:copy>
					</xsl:for-each>
				</tmarc:d245>
			</xsl:if>
			
			<xsl:if test="tmarc:d260">
				<tmarc:d260 i1=" " i2=" ">
					<xsl:for-each select="tmarc:d260/node()">
						<xsl:copy>
							<xsl:apply-templates select="@*|node()"/>
						</xsl:copy>
					</xsl:for-each>
				</tmarc:d260>
			</xsl:if>
			
			<xsl:if test="tmarc:d300">
				<tmarc:d300 i1=" " i2=" ">
					<xsl:for-each select="tmarc:d300/node()">
						<xsl:copy>
							<xsl:apply-templates select="@*|node()"/>
						</xsl:copy>
					</xsl:for-each>
				</tmarc:d300>
			</xsl:if>
			
			<xsl:if test="tmarc:d490">
				<tmarc:d490 i1=" " i2=" ">
					<xsl:for-each select="tmarc:d490/node()">
						<xsl:copy>
							<xsl:apply-templates select="@*|node()"/>
						</xsl:copy>
					</xsl:for-each>
				</tmarc:d490>
			</xsl:if>
			
			<!--
				The URL in 856 $d seems to be only the link to the catalogue page.
				Map it to the catalogue-url field.
			-->
			<xsl:if test="tmarc:d856/tmarc:su">
				<pz:metadata type="catalogue-url">
					<xsl:value-of select="normalize-space(tmarc:d856/tmarc:su)"/>
				</pz:metadata>
			</xsl:if>
			
			
			<!--
				Apply templates to all child nodes.
				The elements we already processed are caught by their own template
				and deleted. The remaining ones are copied over.
			-->
			<xsl:copy>
				<xsl:apply-templates select="node()"/>
			</xsl:copy>
		</tmarc:r>
	</xsl:template>



</xsl:stylesheet>
