<?xml version="1.0" encoding="UTF-8"?>
<!--
	Slight cleanup for GBV Marc Data.

	2010-2012 Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
	2016 Hans-Werner Hilse, SUB Goettingen <hilse@sub.uni-goettingen.de>
-->

<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pz="http://www.indexdata.com/pazpar2/1.0"
	xmlns:tmarc="http://www.indexdata.com/turbomarc">

	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
	<xsl:strip-space elements="*" />

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>



	<!--
		A few GBV databases (e.g. IKAR) return Normsatz records.
		These can be recongised by having 'z' at position 6 of the Marc leader,
		don’t contain data and should not be displayed.
		Delete them.
	-->
	<xsl:template match="tmarc:r">
		<xsl:if test="substring(., 7, 1) != 'z'">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>



	<!--
		Remove leading asterisks from classification.
		Classification information does not include asterisks, they seem to serve
		as some kind of indicator for the main MSC which nobody really cares for.
	-->
	<xsl:template match="tmarc:d084/tmarc:sa/text()">
		<xsl:choose>
			<xsl:when test="substring(., 1, 1) = '*'">
				<xsl:value-of select="substring(., 2)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!--
		Remove 245 $h subfields.
		We want to use the controlled media types from tmarc.xsl only
			and skip the free-text entered in the records.
	-->
	<xsl:template match="tmarc:d245/tmarc:sh"></xsl:template>

	<!--
		Remove 520 $a subfields.
		Remove 505 $a subfields.
		They contain information we don't want to show
	-->
	<xsl:template match="tmarc:d520/tmarc:sa"></xsl:template>
	<xsl:template match="tmarc:d505/tmarc:sa"></xsl:template>


	<!--
		GBV Marc export makes sure that volume numbers and names in
			245 $p and $v subfields always occur in pairs.
		If data for one of the fields is missing, [...] is inserted.
		This is said to be a tacit convention between German union
			catalogues and unlikely to be corrected.
		As displaying [...] is not useful, strip such subfields.
	-->
	<xsl:template match="tmarc:d245/tmarc:sp | tmarc:d245/tmarc:sv">
		<xsl:if test="text()!='[...]'">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>



	<!--
		GBV Online Contents (Swets data) have broken author information.
		Author information is in Pica field 028C (rather than 028A/B)
			and thus converted to Marc 700 without a $4 subfield.
		For Online Contents databases add a '$4 aut' subfield to
			ensure the author is displayed as such.
		We recognise GBV Online Contents data by the Marc 900 $a
			field containing 'OLC'.
	-->
	<xsl:template match="tmarc:d700">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>

			<xsl:if test="../tmarc:d901/tmarc:sa/text() = 'OLC'">
				<tmarc:s4>aut</tmarc:s4>
			</xsl:if>
		</xsl:copy>
	</xsl:template>



	<!--
		GBV Marc-Records reliably use the i1 field of field 856 to indicate
			http (4) and ftp (1) links. 856 fields with a blank i1 field can
			be URNs which are not linkable in the browser.
		Thus remove all 856 fields whose i1 is not 4 or 1.
	-->
	<xsl:template match="tmarc:d856[@i1!='4' and @i1!='1']">
	</xsl:template>



	<!--
		All GBV Records have IDs (PPN) consisting of numbers and potentially
		an X in the last position.
		To ensure uniqueness of the Marc 001 field across records from
		different databases, a capital letter alphabetic prefix is prepended to
		the PPN. This rule removes all capital letters to restore the PPN.
	-->
	<xsl:template match="tmarc:c001">
		<tmarc:c001>
			<xsl:value-of select="translate(substring(., 1, string-length(.)-1), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', '')"/>
			<xsl:value-of select="substring(., string-length(.), 1)"/>
		</tmarc:c001>
	</xsl:template>



	<!--
		GBV (just like SWB) use field 689 for local keywords (Pica field 044K).
		Map those to 690.
	-->
	<xsl:template match="tmarc:d689">
		<tmarc:d690>
			<xsl:apply-templates select="@*|node()"/>
		</tmarc:d690>
	</xsl:template>



	<!--
		Kill 900 and 954 fields with library information.
		There tend to be many of those and we don't use them.
	-->
	<xsl:template match="tmarc:d900|tmarc:d954"></xsl:template>


</xsl:stylesheet>
