<?xml version="1.0" encoding="UTF-8"?>
<!--
	Converts DC Qualified metadata coming from Göttingen DSpace SRU interfaces.
	These contains a few non-standard fields.
		
	2010-2011, Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pz="http://www.indexdata.com/pazpar2/1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:srw_dc="info:srw/schema/1/dc-v1.1">

	<xsl:import href="metadata-splitter.xsl"/>
	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>


	<xsl:template match="srw_dc:dc">
		<xsl:variable name="medium">
			<xsl:choose>
				<xsl:when test="dc:type='book' or dc:type='bookPart' or dc:type='doctoralThesis' or dc:type='Book' or dc:type='periodicalPart'">
					<xsl:text>book</xsl:text>
				</xsl:when>
				<xsl:when test="dc:type='article' or dc:type='lecture' or dc:type='workingPaper'">
					<xsl:text>article</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>electronic</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
		<pz:record>

			<pz:metadata type="id">
				<xsl:value-of select="dc:identifier.uri"/>
			</pz:metadata>

			<xsl:for-each select="dc:title">
				<pz:metadata type="title">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="dc:title.alternative">
				<pz:metadata type="title-remainder">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="dc:contributor.author">
				<pz:metadata type="author">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="dc:contributor.editor">
				<pz:metadata type="other-person" role="editor">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="dc:date.issued">
				<pz:metadata type="date">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="dc:identifier.bibliographicCitation">
				<pz:metadata type="citation">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="dc:publisher">
				<pz:metadata type="publication-name">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="dc:format.extent">
				<pz:metadata type="physical-extent">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:if test="dc:relation.ispartofseries">
				<xsl:choose>
					<xsl:when test="$medium='book'">
						<pz:metadata type="series-title">
							<xsl:value-of select="dc:relation.ispartofseries"/>
						</pz:metadata>
					</xsl:when>
					<xsl:otherwise>
						<pz:metadata type="journal-title">
							<xsl:value-of select="dc:relation.ispartofseries"/>
						</pz:metadata>
				
						<pz:metadata type="journal-subpart">
							<xsl:if test="dc:bibliographicCitation.volume">
								<xsl:text>Vol. </xsl:text>
								<xsl:value-of select="dc:bibliographicCitation.volume"/>
							</xsl:if>
							<xsl:if test="dc:bibliographicCitation.issue">
								<xsl:text>, No. </xsl:text>
								<xsl:value-of select="dc:bibliographicCitation.issue"/>
							</xsl:if>
							<xsl:if test="dc:date.issued">
								<xsl:text> (</xsl:text>
								<xsl:value-of select="dc:date.issued"/>
								<xsl:text>)</xsl:text>
							</xsl:if>
							<xsl:if test="dc:bibliographicCitation.firstPage">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="dc:bibliographicCitation.firstPage"/>
								<xsl:if test="dc:bibliographicCitation.lastPage">
									<xsl:text>-</xsl:text>
									<xsl:value-of select="dc:bibliographicCitation.lastPage"/>
								</xsl:if>
							</xsl:if>
						</pz:metadata>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>

			<xsl:for-each select="dc:bibliographicCitation.volume">
				<pz:metadata type="volume-number">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="dc:bibliographicCitation.issue">
				<pz:metadata type="issue-number">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:if test="dc:bibliographicCitation.firstPage | dc:bibliographicCitation.lastPage">
				<pz:metadata type="pages">
					<xsl:value-of select="dc:bibliographicCitation.firstPage"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="dc:bibliographicCitation.lastPage"/>
				</pz:metadata>
			</xsl:if>

			<xsl:for-each select="dc:relation.hasfile">
				<pz:metadata type="electronic-url" fulltextfile="true">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>
			
			<xsl:for-each select="dc:relation.dfgviewer">
				<pz:metadata type="electronic-url" note="DFG Viewer">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>		

			<xsl:for-each select="dc:identifier.uri">
				<pz:metadata type="catalogue-url">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="dc:identifier.doi">
				<pz:metadata type="doi">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="dc:relation.pISSN">
				<pz:metadata type="pissn">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="dc:relation.eISSN">
				<pz:metadata type="eissn">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="dc:identifier.isbn">
				<pz:metadata type="isbn">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="dc:type.version">
				<pz:metadata type="description">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="dc:description.abstract">
				<pz:metadata type="abstract">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<xsl:for-each select="dc:language.iso">
				<pz:metadata type="language">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:for-each>

			<pz:metadata type="medium">
				<xsl:value-of select="$medium"/>
			</pz:metadata>


			<xsl:for-each select="dc:description.tableofcontents">
				<xsl:call-template name="splitter">
					<xsl:with-param name="list" select="."/>
					<xsl:with-param name="separator" select="'; '"/>
					<xsl:with-param name="metadataType">description</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>

			<xsl:for-each select="dc:subject">
				<xsl:call-template name="splitter">
					<xsl:with-param name="list" select="."/>
					<xsl:with-param name="separator" select="'; '"/>
					<xsl:with-param name="metadataType">subject</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>

		</pz:record>
	</xsl:template>

	

	<!-- Kill stray text -->
	<xsl:template match="text()"/>

</xsl:stylesheet>
