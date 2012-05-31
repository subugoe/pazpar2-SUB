<?xml version="1.0" encoding="UTF-8"?>
<!--
	Preprocesses the IfL Marc format to avoid some problems it causes:
		* merge subfields of repeated Marc fields to a single fields (the subfields
			tend to be split across severeal instances of the main field)
		* write 'medium-override' pz:metadata field using the string in 334 $a
		* convert free-text language names in 041 to language codes
		* write 'catalogue-url' pz:metadata field from URL in 856 $u

	2011-2012
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
	<xsl:template match="tmarc:d245|tmarc:d260|tmarc:d300|tmarc:d490|tmarc:d773|tmarc:d856"/>



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

			<xsl:if test="tmarc:d773">
				<tmarc:d773 i1=" " i2=" ">
					<xsl:for-each select="tmarc:d773/node()">
						<xsl:copy>
							<xsl:apply-templates select="@*|node()"/>
						</xsl:copy>
					</xsl:for-each>
				</tmarc:d773>
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
			<xsl:apply-templates select="*"/>
		</tmarc:r>
	</xsl:template>


	<!--
		IfL Marc records do not contain ISO 639-1B language codes.
	-->
	<xsl:template match="tmarc:d041/tmarc:sa|tmarc:d041/tmarc:sb">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test=". = 'Bulgarisch'">bul</xsl:when>
				<xsl:when test=". = 'Chinesisch'">chi</xsl:when>
				<xsl:when test=". = 'Deutsch'">ger</xsl:when>
				<xsl:when test=". = 'Englisch'">eng</xsl:when>
				<xsl:when test=". = 'Finnisch'">fin</xsl:when>
				<xsl:when test=". = 'Französisch'">fre</xsl:when>
				<xsl:when test=". = 'Isländisch'">ice</xsl:when>
				<xsl:when test=". = 'Italienisch'">ita</xsl:when>
				<xsl:when test=". = 'Japanisch'">jpn</xsl:when>
				<xsl:when test=". = 'Katalanisch'">cat</xsl:when>
				<xsl:when test=". = 'Koreanisch'">kor</xsl:when>
				<xsl:when test=". = 'Kroatisch'">hrv</xsl:when>
				<xsl:when test=". = 'Litauisch'">lit</xsl:when>
				<xsl:when test=". = 'Niederländisch'">dut</xsl:when>
				<xsl:when test=". = 'Norwegisch'">nor</xsl:when>
				<xsl:when test=". = 'Polnisch'">pol</xsl:when>
				<xsl:when test=". = 'Portugiesisch'">por</xsl:when>
				<xsl:when test=". = 'Rumänisch'">rum</xsl:when>
				<xsl:when test=". = 'Russisch'">rus</xsl:when>
				<xsl:when test=". = 'Schwedisch'">swe</xsl:when>
				<xsl:when test=". = 'Slowakisch'">slo</xsl:when>
				<xsl:when test=". = 'Slowenisch'">slv</xsl:when>
				<xsl:when test=". = 'Spanisch'">spa</xsl:when>
				<xsl:when test=". = 'Tschechisch'">cze</xsl:when>
				<xsl:when test=". = 'Ukrainisch'">ukr</xsl:when>
				<xsl:when test=". = 'Ungarisch'">hun</xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>


	<!--
		IfL data do not use Marc media type indicators but contain a string in 334 $a.
		The strings we are aware of are mapped to the medium-override metadata field.
		After running through tmarc.xsl, medium-override.xsl has to run to replace the
		'electronic' media type inserted by tmarc.xsl with the correct one.
	-->
	<xsl:template match="tmarc:d334[1]">
		<pz:metadata type="medium-override">
			<xsl:choose>
				<xsl:when test="tmarc:sa = 'Adressenverzeichnis'">other</xsl:when>
				<xsl:when test="tmarc:sa = 'Amtsdruckschrift'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Atlas'">map</xsl:when>
				<xsl:when test="tmarc:sa = 'Bibliographie'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Bildband'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Biographie'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Buch'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Buchaufsatz'">article</xsl:when>
				<xsl:when test="tmarc:sa = 'CD-ROM'">electronic</xsl:when>
				<xsl:when test="tmarc:sa = 'Datenträger/CD-ROM/Diskette'">electronic</xsl:when>
				<xsl:when test="tmarc:sa = 'Diplomarbeit/Studienabschlussarbeit'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Dissertation'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Einzelband (mehrbändiges Werk)'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Elektronische Ressource'">electronic</xsl:when>
				<xsl:when test="tmarc:sa = 'Exkursionsführer'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Festschrift'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Fortsetzungsteilveröffentlichung'">book</xsl:when> <!-- ? -->
				<xsl:when test="tmarc:sa = 'Fotografie'">image</xsl:when>
				<xsl:when test="tmarc:sa = 'Graue Literatur/Forschungsbericht'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Habilitationsschrift'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Handbuch'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Hochschulschrift'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Jahrbuch'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Karte'">map</xsl:when>
				<xsl:when test="tmarc:sa = 'Katalog'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Kleinschrifttum'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Kongressschrift'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Lehrbuch'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Loseblattsammlung'">other</xsl:when>
				<xsl:when test="tmarc:sa = 'Mehrbändiges Werk'">multivolume</xsl:when>
				<xsl:when test="tmarc:sa = 'Nachschlagewerk'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Online-Ressource'">electronic</xsl:when>
				<xsl:when test="tmarc:sa = 'Reiseführer'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Sammelwerk'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Schriftenreihe'">multivolume</xsl:when>
				<xsl:when test="tmarc:sa = 'Schulbuch'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Sonderdruck'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Tabellenwerk/Zahlenwerk/Statistik'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Tagungsbericht'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Themenheft'">article</xsl:when>
				<xsl:when test="tmarc:sa = 'Vortrag/Vorlesung/Rede'">book</xsl:when>
				<xsl:when test="tmarc:sa = 'Zeitschrift'">journal</xsl:when>
				<xsl:when test="tmarc:sa = 'Zeitschriftenartige Reihe'">journal</xsl:when>
				<xsl:when test="tmarc:sa = 'Zeitschriftenaufsatz'">article</xsl:when>
				<xsl:when test="tmarc:sa = 'Zusammenfassung mehrerer Beiträge'">book</xsl:when>
				<xsl:otherwise>other</xsl:otherwise>
			</xsl:choose>
		</pz:metadata>
	</xsl:template>

</xsl:stylesheet>
