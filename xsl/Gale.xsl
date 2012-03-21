<?xml version="1.0" encoding="UTF-8"?>
<!--
	Preprocesses the Gale Marc format to work around some issues it presents:

	2012
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
		Most records seem to contain 'Journal article' in Marc 500 $a.
		As this is already expressed by the media type, remove that comment.
	-->
	<xsl:template match="tmarc:d500/tmarc:sa[text()='Journal article']">
	</xsl:template>



	<!--
		Delete the catalogue URL which appears in Marc 856 as we build them based on the id.
	-->
	<xsl:template match="tmarc:d856">
		<xsl:if test="substring(tmarc:su, 1, 30) != 'http://infotrac.galegroup.com/'">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>



	<!--
		Gale records place several bits of information in Marc 900 fields
		instead of the appropriate fields.

		Try to extract as much information as possible.
	-->
	<xsl:template match="tmarc:d900">
		<!--
			ISSN/ISBN infomration is sent in Marc 900 $5.
			Try to determine the type of the number in that field by the heuristic
			length without dashes =  8 -> ISSN
			                      = 10 -> ISBN
			                      = 13 -> ISBN
		-->
		<xsl:for-each select="tmarc:s5">
			<xsl:variable name="cleanString" select="translate(., '-', '')"/>
			<xsl:choose>
				<xsl:when test="string-length($cleanString) = 8">
					<pz:metadata type="issn">
						<xsl:value-of select="."/>
					</pz:metadata>
				</xsl:when>
				<xsl:when test="string-length($cleanString) = 10 or string-length($cleanString) = 13">
					<pz:metadata type="isbn">
						<xsl:value-of select="."/>
					</pz:metadata>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>


		<!--
			Free text language names are in Marc 900 $4
			instead of language codes into c008 or 041.

			Map the random subset we are aware of to their corresponging ISO 639-2/B codes.
		-->
		<xsl:for-each select="tmarc:s4">
			<xsl:variable name="language">
				<xsl:choose>
					<xsl:when test=". = 'Afrikaans'">afr</xsl:when>
					<xsl:when test=". = 'Chinese'">chi</xsl:when>

					<xsl:when test=". = 'English'">eng</xsl:when>
					<xsl:when test=". = 'French'">fre</xsl:when>
					<xsl:when test=". = 'German'">ger</xsl:when>
					<xsl:when test=". = 'Hungarian'">hun</xsl:when>
					<xsl:when test=". = 'Portuguese'">por</xsl:when>
					<xsl:when test=". = 'Slovenian'">slv</xsl:when>
					<xsl:when test=". = 'Spanish'">spa</xsl:when>
					<xsl:when test=". = 'Ukrainian'">ukr</xsl:when>
					<xsl:otherwise>
						<xsl:text>!</xsl:text>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="$language != ''">
				<pz:metadata type="language">
					<xsl:value-of select="$language"/>
				</pz:metadata>
			</xsl:if>
		</xsl:for-each>


		<!--
			A »citation« is provided in Marc 900 $s. Try to extract some
			very rough additional information from that.
		-->
		<xsl:for-each select="tmarc:ss">
			<xsl:variable name="details" select="normalize-space(substring-after(substring-after(., ../../tmarc:d773/tmarc:st), ','))"/>

			<pz:metadata type="journal-subpart">
				<xsl:value-of select="$details"/>
			</pz:metadata>

			<pz:metadata type="citation">
				<xsl:value-of select="."/>
			</pz:metadata>
		</xsl:for-each>

	</xsl:template>


</xsl:stylesheet>
