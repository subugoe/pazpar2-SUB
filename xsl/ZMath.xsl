<?xml version="1.0" encoding="UTF-8"?>
<!--
	Converts ZMath records for pazpar2.

	December 2010
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->

<xsl:stylesheet
		version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:pz="http://www.indexdata.com/pazpar2/1.0"
		xmlns:dc="http://purl.org/dc/elements/1.1/">

	<xsl:import href="metadata-splitter.xsl"/>
	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

	<xsl:param name="has_fulltext"/>


	<xsl:template match="record|rec">
		<pz:record>

			<pz:metadata type="id">
				<xsl:value-of select="normalize-space(an)"/>
			</pz:metadata>

			<xsl:for-each select="ti">
				<pz:metadata type="title">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="au|authors/au">
				<pz:metadata type="author">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="rv">
				<pz:metadata type="reviewer">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="ut|terms/ut">
				<pz:metadata type="subject" accordingto="Zentralblatt Math">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="cc|classification/cc">
				<pz:metadata type="classification-msc" accordingto="Zentralblatt Math">
					<xsl:choose>
						<xsl:when test="substring(., 1 , 1) = '*'">
							<xsl:attribute name="default">yes</xsl:attribute>
							<xsl:value-of select="substring-after(., '*')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="py">
				<xsl:call-template name="splitter">
					<xsl:with-param name="list" select="."/>
					<xsl:with-param name="separator">, </xsl:with-param>
					<xsl:with-param name="metadataType">date</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>

			<!-- not ideal: This contains the information of the journal-title
					as well as the journal-subpart field.
			-->
			<xsl:for-each select="so">
				<pz:metadata type="journal-title">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="is">
				<pz:metadata type="issn">
					<xsl:choose>
						<!-- ELibM ISSN entries occasionally come with a leading 'ISSN' -->
						<xsl:when test="substring(., 1, 4) = 'ISSN'">
							<xsl:value-of select="normalize-space(substring(., 5))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="et">
				<pz:metadata type="electronic-url">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="la">
				<pz:metadata type="language">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="ab">
				<pz:metadata type="abstract">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="dt">
				<pz:metadata type="medium">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:if test="$has_fulltext = 'yes'">
				<pz:metadata type="has-fulltext">yes</pz:metadata>
			</xsl:if>

		</pz:record>
	</xsl:template>

	<!-- Kill stray text -->
	<xsl:template match="text()"/>

</xsl:stylesheet>
