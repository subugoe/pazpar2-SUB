<?xml version="1.0" encoding="UTF-8"?>
<!--
	Post-processes records coming from the ssgfi1 Solr index after
	they are processed by solr-pz2.xsl.

	2011-2012 Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->

<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pz="http://www.indexdata.com/pazpar2/1.0">

	<xsl:import href="iso-639-1-to-639-2b.xsl"/>

	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- Type: Media Types for digreg -->
	<xsl:template match="pz:metadata[@type='Type']">
		<pz:metadata type="medium">
			<xsl:choose>
				<xsl:when test=". = 'on'">website</xsl:when>
				<xsl:when test=". = 'Article'">article</xsl:when>
				<xsl:when test=". = 'Conference Article'">article</xsl:when>
				<xsl:when test=". = 'Conference Proceedings'">book</xsl:when>
				<xsl:when test=". = 'Habilitation'">book</xsl:when>
				<xsl:when test=". = 'Journal'">journal</xsl:when>
				<xsl:when test=". = 'Monograph'">book</xsl:when>
				<xsl:when test=". = 'Movie'">audio-visual</xsl:when>
				<xsl:when test=". = 'Multivolume Work'">book</xsl:when> <!-- apparently used for volumes in a multivolume work -->
				<xsl:when test=". = 'Periodical Volume'">journal</xsl:when>
				<xsl:when test=". = 'Project'">website</xsl:when>
				<xsl:when test=". = 'Report'">book</xsl:when>
				<xsl:when test=". = 'Review'">article</xsl:when>
				<xsl:when test=". = 'Serial Material'">multivolume</xsl:when> <!-- apparently used the multivolume work itself -->
				<xsl:when test=". = 'Thesis'">book</xsl:when>
				<xsl:when test=". = 'Video'">audio-visual</xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</pz:metadata>
	</xsl:template>

	<!-- Source_Type: Media Types for jfm -->
	<xsl:template match="pz:metadata[@type='Source_Type']">
		<pz:metadata type="medium">
			<xsl:choose>
				<xsl:when test=". = 'B'">book</xsl:when> <!-- Book -->
				<xsl:when test=". = 'D'">book</xsl:when> <!-- Dissertation -->
				<xsl:when test=". = 'J'">article</xsl:when> <!-- Journal Article -->
				<xsl:otherwise>article</xsl:otherwise> <!-- Let everything else appear as an article as well -->
			</xsl:choose>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='Author']">
		<pz:metadata type="author">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='Publisher']">
		<pz:metadata type="title-responsibility">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='Editor']">
		<pz:metadata type="other-person">
			<xsl:value-of select="."/>
			<xsl:text> (Ed.)</xsl:text>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='Title']">
		<pz:metadata type="title">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='ISBN/ISSN']">
		<xsl:choose>
			<xsl:when test="substring(., 1, 4) = 'ISBN'">
				<pz:metadata type="isbn">
					<xsl:value-of select="normalize-space(substring(., 5))"/>
				</pz:metadata>
			</xsl:when>
			<xsl:when test="substring(., 1, 4) = 'ISSN'">
				<pz:metadata type="issn">
					<xsl:value-of select="normalize-space(substring(., 5))"/>
				</pz:metadata>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- In JfM 'Source' contains information about the 'container' of the current item. -->
	<xsl:template match="pz:metadata[@type='Source']">
		<pz:metadata>
			<xsl:attribute name="type">
				<xsl:choose>
					<xsl:when test="../pz:metadata[@type='Journal']">
						<xsl:text>journal-subpart</xsl:text>
					</xsl:when>
					<xsl:when test="../pz:metadata[@type='Source_Type'] = 'B' or ../pz:metadata[@type='Source_Type'] = 'D'">
						<xsl:text>title-remainder</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>journal-title</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='Journal']">
		<pz:metadata type="journal-title">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='Volume']">
		<pz:metadata type="volume-number">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='Issue']">
		<pz:metadata type="issue-number">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='Page']">
		<pz:metadata type="pages-number">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='Year']">
		<pz:metadata type="date">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='URL']">
		<pz:metadata type="electronic-url">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<!-- Classification information, mapped to the respective classification fields. -->
	<xsl:template match="pz:metadata[@type='DDC']">
		<pz:metadata type="classification-ddc">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='MSC']">
		<pz:metadata type="classification-msc">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<!-- Textual subject information, all mapped to 'subject'. -->
	<xsl:template match="pz:metadata[@type='MSCverbal']">
		<pz:metadata type="subject">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='Keywords']">
		<pz:metadata type="subject">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='LCSH']">
		<pz:metadata type="subject">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<!-- Description fields, populated from:
			* Translated (English titles for texts, e.g. from RusDML)
			* Description
			* Notes
			* Size/Quality
	-->
	<xsl:template match="pz:metadata[@type='Translated']">
		<pz:metadata type="description">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='Description']">
		<pz:metadata type="description">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='Notes']">
		<pz:metadata type="description">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='Size/Quality']">
		<pz:metadata type="description">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='Zbl'] | pz:metadata[@type='Zbl-Nr.']">
		<pz:metadata type="description">
			<xsl:text>Zbl </xsl:text>
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='MR']">
		<pz:metadata type="electronic-url" note="MathSciNet Review">
			<xsl:text>http://www.ams.org/mathscinet-getitem?mr=</xsl:text>
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>


	<!-- Data origin information. -->
	<xsl:template match="pz:metadata[@type='Data_Source']">
		<pz:metadata type="creator">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='Contained_in']">
		<xsl:if test="not(substring(., 1, 4) = 'http')">
			<pz:metadata type="edition">
				<xsl:value-of select="."/>
			</pz:metadata>
		</xsl:if>
	</xsl:template>

	<!-- Media Types -->
	<xsl:template match="pz:metadata[@type='Source_Code']">
		<pz:metadata type="source-type">
			<xsl:choose>
				<xsl:when test="substring(., 1, 2) = 'sf'">sf</xsl:when>
				<xsl:when test=". = 'so1'">so1</xsl:when>
				<xsl:when test=". = 'so2'">so2</xsl:when>
				<xsl:when test="substring(., 1, 2) = 'sc'">sc</xsl:when>
				<xsl:when test=". = 'pe' or . = 'au'">per</xsl:when>
				<xsl:when test="substring(., 1, 2) = 'ej' or . = 'we' or . = 'ak' or . = 'oe' or . = 'tm' or . = 'ts'">ref</xsl:when>
				<xsl:when test=". = 'd6' or substring(., 1, 2) = 'q6' or . = 'etc-prim'">dat</xsl:when>
				<xsl:when test=". = 'a2' or . = 'le' or .= 'hb'">man</xsl:when>
				<xsl:when test=". = 'fp'">fp</xsl:when>
				<xsl:when test=". = 'kn'">kn</xsl:when>
				<xsl:when test="substring(., 1, 2) = 'ay' or . = 'ff' or . = 'is' or . = 'sw'">web</xsl:when>
				<xsl:when test="substring(., 1, 2) = 'bl'">bl</xsl:when>
				<xsl:when test=". = 'lb' or . = 'ar' or substring(., 1, 2) = 'kb' or . = 'etc-bib'">lib</xsl:when>
				<xsl:when test=". = 'bb' or . = 'mp'">img</xsl:when>
				<xsl:when test=". = 'mu' or . = 'at'">mus</xsl:when>
				<xsl:when test=". = 'do'">do</xsl:when>
				<xsl:when test="substring(., 1, 2) = 'ka'">ka</xsl:when>
				<xsl:when test="substring(., 1, 2) = 'vc'">vc</xsl:when>
				<xsl:when test="substring(., 1, 2) = 'fd' or substring(., 1, 1) = 'z' or substring(., 1, 2) = 'eb'">art</xsl:when>
				<!-- currently dropped: dg, etc-info, gs, etc-fact -->
			</xsl:choose>
		</pz:metadata>
	</xsl:template>

	<!-- Country -->
	<xsl:template match="pz:metadata[@type='Country']">
		<pz:metadata type="country">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<!-- Language:
			* Call iso-639-1-converter template from iso-639-1-to-639-2b.xsl.
			* Use the first two characters of the field content only.
	-->
	<xsl:template match="pz:metadata[@type='Language']">
		<pz:metadata type="language">
			<xsl:call-template name="iso-639-1-converter">
				<xsl:with-param name="languageCode" select="substring(., 1, 2)"/>
			</xsl:call-template>
		</pz:metadata>
	</xsl:template>


</xsl:stylesheet>
