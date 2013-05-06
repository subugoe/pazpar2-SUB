<?xml version="1.0" encoding="UTF-8"?>
<!--
	Massage records harvested Pangaea.

	Compared to OAI-DC records these may contain the additional fields
		* relation-url_s: URL linking to the item noted in relation
		* geo-[east|west|north|south]_f: coordinates
		* project-name_s: name of related project
		* project-url_s: URL linking to related project

	2013 Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->

<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pz="http://www.indexdata.com/pazpar2/1.0">

	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>



	<!--
		relation:
		If a corresponding relation-url_s field exists for a relation field,
		turn it into a link using the relation as its label.
		Otherwise copy the field as is.
	-->
	<xsl:template match="pz:metadata[@type='relation']">
		<xsl:choose>
			<xsl:when test="../pz:metadata[@type='relation-url_s'][position()]">
				<pz:metadata type="electronic-url" name="related">
					<xsl:value-of select="../pz:metadata[@type='relation-url_s'][position()]"/>
				</pz:metadata>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!--
		geo-[east|west|north|south]_f:
		If all of these exist, create a mapscale field with coordinates attribute
		containing the coordinates in a form similar to ISBD
		(E/W/N/S + decimal degrees) with / and a double - as separators.
	-->
	<xsl:template match="pz:metadata[@type='geo-west_f']">
		<xsl:if test="../pz:metadata[@type='geo-east_f'][position()]
						and ../pz:metadata[@type='geo-north_f'][position()]
						and ../pz:metadata[@type='geo-west_f'][position()]">
			<pz:metadata type="mapscale" empty="PZ2_EMPTY">
				<xsl:attribute name="coordinates">
					<xsl:call-template name="coordinates2ISBD">
						<xsl:with-param name="west" select="."/>
						<xsl:with-param name="east" select="../pz:metadata[@type='geo-east_f'][position()]"/>
						<xsl:with-param name="north" select="../pz:metadata[@type='geo-north_f'][position()]"/>
						<xsl:with-param name="south" select="../pz:metadata[@type='geo-south_f'][position()]"/>
					</xsl:call-template>
				</xsl:attribute>
			</pz:metadata>		
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="pz:metadata[@type='geo-east_f' or @type='geo-north_f' or @type='geo-south_f']"/>


	<xsl:template name="coordinates2ISBD">
		<xsl:param name="west"/>
		<xsl:param name="east"/>
		<xsl:param name="north"/>
		<xsl:param name="south"/>

		<xsl:if test="string-length($west) &gt; 0 and string-length($east) &gt; 0
						and string-length($north) &gt; 0 and string-length($south) &gt; 0">
			<xsl:call-template name="coordinate2ISBD">
				<xsl:with-param name="type" select="'longitude'"/>
				<xsl:with-param name="coordinate" select="$west"/>
			</xsl:call-template>
			<xsl:text>--</xsl:text>
			<xsl:call-template name="coordinate2ISBD">
				<xsl:with-param name="type" select="'longitude'"/>
				<xsl:with-param name="coordinate" select="$east"/>
			</xsl:call-template>
			<xsl:text>/</xsl:text>
			<xsl:call-template name="coordinate2ISBD">
				<xsl:with-param name="type" select="'latitude'"/>
				<xsl:with-param name="coordinate" select="$north"/>
			</xsl:call-template>
			<xsl:text>--</xsl:text>
			<xsl:call-template name="coordinate2ISBD">
				<xsl:with-param name="type" select="'latitude'"/>
				<xsl:with-param name="coordinate" select="$south"/>
			</xsl:call-template>		
		</xsl:if>
	</xsl:template>

	<xsl:template name="coordinate2ISBD">
		<xsl:param name="type"/>
		<xsl:param name="coordinate"/>

		<xsl:choose>
			<xsl:when test="substring($coordinate, 1, 1) = '-'">
				<xsl:choose>
					<xsl:when test="$type = 'longitude'">W</xsl:when>
					<xsl:when test="$type = 'latitude'">S</xsl:when>
					<xsl:otherwise>?</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:value-of select="substring($coordinate, 2)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$type = 'longitude'">E</xsl:when>
					<xsl:when test="$type = 'latitude'">N</xsl:when>
					<xsl:otherwise>?</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$coordinate"/>
			</xsl:otherwise>			
		</xsl:choose>
		<xsl:text>°</xsl:text>
	</xsl:template>
	
	
	
	<!--
		Project information
		Map to a description field.
	-->
	<xsl:template match="pz:metadata[@type='project-name_s']">
		<xsl:choose>
			<xsl:when test="../pz:metadata[@type='project-url_s'][position()]">
				<pz:metadata type="electronic-url" name="{text()}">
					<xsl:value-of select="../pz:metadata[@type='project-url_s'][position()]"/>
				</pz:metadata>
			</xsl:when>
			<xsl:otherwise>
				<pz:metadata type="description">
					<xsl:value-of select="text()"/>
				</pz:metadata>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='project-url_s']"/>

</xsl:stylesheet>
