<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pz2="http://www.indexdata.com/pazpar2/1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="pz2">

	<xsl:output method="html"
				cdata-section-elements="style"
				indent="yes"
				encoding="utf-8"/>

	<xsl:template match="/">
		<html>
			<xsl:call-template name="html-head"/>
			<body>
				<xsl:apply-templates select="pz2:service"/>
			</body>
		</html>
	</xsl:template>


	<xsl:template match="pz2:service">
		<h2>
			<xsl:text>Service </xsl:text>
			<span class="name">
				<xsl:value-of select="@id"/>
			</span>
		</h2>

		<xsl:apply-templates select="./comment()[1]"/>

		<xsl:variable name="settings-paths" select="pz2:settings/@src"/>

		<h2>Databases</h2>
		<ul>
			<xsl:for-each select="pz2:settings/pz2:set[@name='pz:name']|pz2:settings[@src]">
				<xsl:choose>
					<xsl:when test="@name">
						<xsl:call-template name="database-info">
							<xsl:with-param name="set" select="."/>
							<xsl:with-param name="settings-paths" select="$settings-paths"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="document(concat('../../', @src))//pz2:set[@name='pz:name']">
							<xsl:call-template name="database-info">
								<xsl:with-param name="set" select="."/>
								<xsl:with-param name="settings-paths" select="$settings-paths"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</ul>

		<h2>Metadata Fields</h2>
		<ul class="metadata">
			<xsl:for-each select="pz2:metadata">
				<li>
					<xsl:attribute name="class">
						<xsl:if test="./@brief = 'yes'">brief </xsl:if>
						<xsl:if test="./@termlist = 'yes'">termlist </xsl:if>
						<xsl:if test="./@mergekey and ./@mergekey != 'no'">mergekey </xsl:if>
						<xsl:if test="./@setting">setting </xsl:if>
					</xsl:attribute>
					<span class="name">
						<xsl:value-of select="./@name"/>
					</span>
					<ul class="metadata-details">
						<xsl:if test="not(./@brief ='yes')">
							<li class="brief">Only appears in full records</li>
						</xsl:if>
						<xsl:if test="./@termlist = 'yes'">
							<li class="termlist">
								<xsl:text>Create Facets</xsl:text>
							</li>
						</xsl:if>
						<xsl:if test="./@merge">
							<li class="merge">
								<xsl:text>Merge: </xsl:text>
								<xsl:value-of select="./@merge"/>
							</li>
						</xsl:if>
						<xsl:if test="./@mergekey">
							<li class="mergekey">
								<xsl:text>Used in mergekey: </xsl:text>
								<xsl:value-of select="./@mergekey"/>
							</li>
						</xsl:if>
						<xsl:if test="./@sortkey">
							<li class="sortkey">
								<xsl:text>Sortkey: </xsl:text>
								<xsl:value-of select="./@sortkey"/>
							</li>
						</xsl:if>
						<xsl:if test="./@limitmap">
							<li class="limitmap">
								<xsl:text>Used limitmap: </xsl:text>
								<xsl:value-of select="./@limitmap"/>
							</li>
						</xsl:if>
						<xsl:if test="./@setting">
							<li class="setting">
								<xsl:text>Setting: </xsl:text>
								<xsl:value-of select="./@setting"/>
							</li>
						</xsl:if>
					</ul>
				</li>
			</xsl:for-each>
		</ul>

	</xsl:template>


	<xsl:template name="database-info">
		<xsl:param name="set"/>
		<xsl:param name="settings-paths"/>
		<xsl:variable name="database-name" select="translate($set/@target, ':/.-', '____')"/>

		<li class="database">
			<xsl:attribute name="id">
					<xsl:value-of select="concat('li-', $database-name)"/>
			</xsl:attribute>
			<xsl:attribute name="onclick">
				<xsl:text>jQuery('#li-</xsl:text>
				<xsl:value-of select="$database-name"/>
				<xsl:text> .details').toggle('fast');</xsl:text>
			</xsl:attribute>
			<span class="name">
				<xsl:value-of select="$set/@value"/>
			</span>

			<xsl:variable name="database-address" select="$set/@target"/>
			<xsl:text> </xsl:text>
			<span class="target">
				<xsl:value-of select="$database-address"/>
			</span>
			<xsl:text> </xsl:text>

			<div class="details">
				<!-- Go through settings files to find relevant settings -->
				<xsl:for-each select="$settings-paths">
					<xsl:variable name="settings-path" select="."/>
					<xsl:for-each select="document(concat('../../', $settings-path))/pz2:settings">
						<xsl:variable name="target-address" select="translate(./@target, '*', '')"/>
						<xsl:if test="substring($database-address, 1, string-length($target-address)) = $target-address">
							<!-- This settings file is relevant: extract settings. -->

							<xsl:variable name="settings" select="pz2:set[not(@target) or substring($database-address, 1, string-length(translate(@target, '*', ''))) = translate(@target, '*', '')]"/>

							<h4>
								<xsl:text>Settings from </xsl:text>
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="concat('../', $settings-path)"/>
									</xsl:attribute>
									<xsl:value-of select="$settings-path"/>
								</a>
							</h4>

							<dl>
								<xsl:for-each select="$settings">
									<xsl:call-template name="show-setting">
										<xsl:with-param name="name" select="./@name"/>
										<xsl:with-param name="value" select="./@value"/>
									</xsl:call-template>
								</xsl:for-each>
							</dl>

						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
			</div>
		</li>
	</xsl:template>


	<xsl:template name="show-setting">
		<xsl:param name="name"/>
		<xsl:param name="value"/>

		<dt>
			<xsl:attribute name="title">
				<xsl:value-of select="$name"/>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="$name='pz:sru'">Protocol</xsl:when>
				<xsl:when test="$name='pz:sru_version'">Protocol-Version</xsl:when>
				<xsl:when test="substring($name, 1, 9) = 'pz:cclmap'">
					<span class="prefix"><xsl:text>Search Key </xsl:text></span>
					<xsl:value-of select="substring($name, 11)"/>
				</xsl:when>
				<xsl:when test="substring($name, 1, 11) = 'pz:limitmap'">
					<span class="prefix"><xsl:text>Limit Map </xsl:text></span>
					<xsl:value-of select="substring($name, 13)"/>
				</xsl:when>
				<xsl:when test="$name = 'pz:xslt'">XSL</xsl:when>
				<xsl:when test="$name = 'pz:maxrecs'">Maximum Records to fetch</xsl:when>
				<xsl:when test="$name = 'pz:allow'">Database active</xsl:when>
				<xsl:when test="$name = 'catalogueURLHintPrefix'">Catalogue URL Prefix</xsl:when>
				<xsl:when test="substring($name, 1, 3) = 'pz:'">
					<xsl:value-of select="substring($name, 4)"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$name"/></xsl:otherwise>
			</xsl:choose>
		</dt>
		<dd>
			<xsl:attribute name="title">
				<xsl:value-of select="$name"/>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="$name='pz:sru'">
					<xsl:choose>
						<xsl:when test="$value = 'solr'">
							<xsl:text>Solr</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>SRU </xsl:text>
							<xsl:value-of select="$value"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="substring($name, 1, 9) = 'pz:cclmap'">
					<xsl:call-template name="cclmap-to-text">
						<xsl:with-param name="string" select="$value"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="substring($name, 1, 11) = 'pz:limitmap'">
					<xsl:call-template name="cclmap-to-text">
						<xsl:with-param name="string" select="$value"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$name = 'pz:xslt'">
					<xsl:call-template name="xslt-to-text">
						<xsl:with-param name="string" select="$value"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$name = 'pz:allow'">
					<xsl:choose>
						<xsl:when test="$value = '0'">No</xsl:when>
						<xsl:when test="$value = '1'">Yes</xsl:when>
						<xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$name = 'catalogueURLHintPrefix'">
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="$value"/>
						</xsl:attribute>
						<xsl:value-of select="$value"/>
					</a>
				</xsl:when>
				<xsl:when test="substring($name, 1, 3) = 'pz:'">
					<xsl:value-of select="substring($name, 4)"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
			</xsl:choose>
		</dd>
	</xsl:template>



	<xsl:template name="cclmap-to-text">
		<xsl:param name="string"/>

		<xsl:call-template name="cclmap-splitter">
			<xsl:with-param name="list" select="$string"/>
			<xsl:with-param name="separator" select="' '"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="xslt-to-text">
		<xsl:param name="string"/>

		<ol>
			<xsl:call-template name="xslt-splitter">
				<xsl:with-param name="list" select="$string"/>
				<xsl:with-param name="separator" select="','"/>
			</xsl:call-template>
		</ol>
	</xsl:template>

	<xsl:template name="cclmap-postprocess">
		<xsl:param name="string"/>
		<span class="cclmap-part">
			<xsl:choose>
				<xsl:when test="contains($string, '=')">
					<xsl:variable name="type" select="substring-before($string, '=')"/>
					<xsl:variable name="value" select="substring-after($string, '=')"/>
					<span class="cclmap-type">
						<xsl:value-of select="$type"/>
					</span>
					<xsl:text>=</xsl:text>
					<span class="cclmap-value">
						<xsl:value-of select="$value"/>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$string"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text> </xsl:text>
		</span>
	</xsl:template>


<!--
	<xsl:template match="pz2:settings">
		<xsl:if test="@src">
			<xsl:apply-templates select="document(concat('./', @src))/pz2:settings"/>
		</xsl:if>

		<xsl:if test="@target">
			<h3>
				<span class="url">
					<xsl:value-of select="@target"/>
				</span>
			</h3>
		</xsl:if>

		<xsl:if test="pz2:set">
			<ul>
				<xsl:for-each select="pz2:set">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>
-->


<!--
	<xsl:template name="protocol-info">
		<xsl:param name="settings"/>

		<xsl:variable name="protocol" select="$settings/pz2:set[@name='pz:sru']"/>
		<xsl:variable name="protocol-version" select="$settings/pz2:set[@name='pz:sru_version']"/>
		<xsl:variable name="protocol-string">
			<xsl:choose>
				<xsl:when test="$protocol">
					<xsl:choose>
						<xsl:when test="$protocol = 'solr'">
							<xsl:text>Solr</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>SRU </xsl:text>
							<xsl:value-of select="$settings/pz2:set[@name='pz:sru']"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="$settings/pz2:set[@name='pz:sru_version']">
						<xsl:text> </xsl:text>
						<xsl:value-of select="$protocol-version"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Z39.50</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<dt>Protocol</dt>
		<dd>
			<xsl:value-of select="$protocol-string"/>
		</dd>
	</xsl:template>
-->

<!--
	<xsl:template match="pz2:settings[@src]">
		<xsl:apply-templates select="document(concat('./', @src))/pz2:settings"/>

		<h3>
			<span class="url">
				<xsl:value-of select="document(concat('./', @src))/pz2:settings/@target"/>
			</span>
		</h3>

		<xsl:variable name="protocol" select="pz2:set[@name='pz:sru']"/>
		<xsl:value-of select="$protocol"/>
		<xsl:variable name="protocol-version" select="pz2:set[@name='pz:sru_version']"/>
		<xsl:variable name="protocol-string">
			<xsl:choose>
				<xsl:when test="$protocol">
					<xsl:choose>
						<xsl:when test="$protocol = 'solr'">
							<xsl:text>Solr</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>SRU </xsl:text>
							<xsl:value-of select="pz2:set[@name='pz:sru']"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="pz2:set[@name='pz:sru_version']">
						<xsl:text> </xsl:text>
						<xsl:value-of select="$protocol-version"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Z39.50</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<dl>
			<dt>
				<xsl:text>Protocol</xsl:text>
			</dt>
			<dd>
				<xsl:value-of select="$protocol-string"/>
			</dd>
		</dl>
		<ul>
			<xsl:apply-templates select="document(concat('./', @src))/pz2:settings"/>
		</ul>

	</xsl:template>
-->

	<xsl:template match="pz2:set">
		<li class="set">
			<xsl:if test="@target">
				<span class="target">
					<xsl:value-of select="@target"/>
				</span>
			</xsl:if>
			<xsl:text> </xsl:text>
			<span class="name">
				<xsl:value-of select="substring-after(@name, 'pz:')"/>
				<xsl:if test="not(contains(@name, 'pz:'))">
					<xsl:value-of select="@name"/>
				</xsl:if>
				<xsl:text>: </xsl:text>
			</span>
			<span class="value">
				<xsl:value-of select="@value"/>
			</span>
		</li>
	</xsl:template>


	<xsl:template match="pz2:metadata">

	</xsl:template>

	<xsl:template match="comment()">
		<pre class="comment">
			<xsl:value-of select="."/>
		</pre>
	</xsl:template>

	<xsl:template name="html-head">
		<xsl:copy>
			<head>
				<title>Title</title>
				<style type="text/css">
					<![CDATA[
					body {
						font-family: Tahoma, sans-serif;
						background: #eee;
						color: #111;
						line-height: 140%;
					}
					h3 {
						clear: both;
						margin-top: 2em;
					}
					a {
						text-decoration: none;
					}
					dt {
						width: 15em;
						float: left;
						clear: left;
						text-align: right;
						font-weight: bold;
					}
					dt:after {
						content: ':';
					}
					dd {
						margin-left: 16em;
					}
					.details {
						display: none;
					}
					.prefix {
						font-weight: normal;
					}
					.target {
						color: #666;
					}
					.name {
						font-weight: bold;
					}
					.metadata>li {
						text-decoration: line-through;
						color: #666;
					}
					.metadata>li.brief, .metadata>li.mergekey, .metadata>li.setting {
						text-decoration: none;
						color: #111;
					}
					.metadata ul {
						display: inline;
						list-style-type: none;
						color: #666;
						font-style: italic;
						padding: 0;
					}
					.metadata ul li {
						display: inline;
						margin-left: 1em;
					}
					.metadata ul li:before {
						content: '‣';
						padding-right: 0.3em;
						font-style: normal;
					}
					.metadata ul li.termlist {
						font-weight: bold;
					}
					]]>
				</style>
				<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
			</head>
		</xsl:copy>
	</xsl:template>




	<xsl:template name="cclmap-splitter">
		<xsl:param name="list"/>
		<xsl:param name="separator"/>

		<xsl:variable name="firstItem">
			<xsl:choose>
				<xsl:when test="contains($list, $separator)">
					<xsl:value-of select="normalize-space(substring-before($list, $separator))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$list"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="remainingItems" select="substring-after($list, $separator)"/>


		<xsl:if test="$firstItem">
			<xsl:call-template name="cclmap-postprocess">
				<xsl:with-param name="string" select="$firstItem"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="$remainingItems">
			<xsl:call-template name="cclmap-splitter">
				<xsl:with-param name="list" select="$remainingItems"/>
				<xsl:with-param name="separator" select="$separator"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<xsl:template name="xslt-splitter">
		<xsl:param name="list"/>
		<xsl:param name="separator"/>

		<xsl:variable name="firstItem">
			<xsl:choose>
				<xsl:when test="contains($list, $separator)">
					<xsl:value-of select="normalize-space(substring-before($list, $separator))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$list"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="remainingItems" select="substring-after($list, $separator)"/>

		<xsl:if test="$firstItem">
			<li>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat('../', $firstItem)"/>
					</xsl:attribute>
					<xsl:value-of select="$firstItem"/>
				</a>
			</li>
		</xsl:if>

		<xsl:if test="$remainingItems">
			<xsl:call-template name="xslt-splitter">
				<xsl:with-param name="list" select="$remainingItems"/>
				<xsl:with-param name="separator" select="$separator"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


</xsl:stylesheet>
