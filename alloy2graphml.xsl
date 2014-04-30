<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:y="http://www.yworks.com/xml/graphml"
	xmlns="http://graphml.graphdrawing.org/xmlns">
	<!-- Stylesheet that outputs the XML tree structure to GraphML. The output 
		graph depicts the element tree of the XML file. The edges of the graph connect 
		each child element with its parent element. -->
	<xsl:output method="xml" indent="yes" />
	        <xsl:variable name="shiftUp" select="'shiftUp'"/>
	        <xsl:variable name="drives" select="'drives'"/>
	        <xsl:variable name="gears" select="'gears'"/>
	        <xsl:variable name="powered" select="'powered'"/>
	        <xsl:variable name="nextGear" select="'nextGear'"/>
	        <xsl:variable name="previousGear" select="'previousGear'"/>
	        <xsl:variable name="shiftDown" select="'shiftDown'"/>
	        <xsl:variable name="threshold" select="'threshold'"/>
	        <xsl:variable name="throttlebreakpoints" select="'throttlebreakpoints'"/>
	<xsl:template match="/">
		<graphml xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns http://www.yworks.com/xml/schema/graphml/1.1/ygraphml.xsd">
			<key id="d0" for="node" yfiles.type="nodegraphics" />
			<key id="d1" for="edge" yfiles.type="edgegraphics" />
			<key id="d2" for="graph" yfiles.type="postprocessors" />
			<graph id="G" edgedefault="directed">
				<xsl:apply-templates select="/alloy/instance/sig/atom"
					mode="create-nodes" />
				<xsl:apply-templates select="alloy/instance/field/tuple"
					mode="create-edges" />
				<data key="d2">
					<y:Postprocessors>
						<y:Processor class="demo.io.graphml.NodeSizeAdapter">
							<y:Option name="IGNORE_WIDTHS" value="false" />
							<y:Option name="IGNORE_HEIGHTS" value="false" />
							<y:Option name="ADAPT_TO_MAXIMUM_NODE" value="false" />
						</y:Processor>
						<y:Processor class="y.module.IncrementalHierarchicLayoutModule">
							<y:Option name="VISUAL.PREFERRED_EDGE_LENGTH" value="90" />
							<y:Option name="ALGORITHM.QUALITY_TIME_RATIO" value="1.0" />
							<y:Option name="VISUAL.OBEY_NODE_SIZES" value="true" />
							<y:Option name="ALGORITHM.MAXIMAL_DURATION" value="30" />
							<y:Option name="VISUAL.ALLOW_NODE_OVERLAPS" value="false" />
							<y:Option name="GENERAL.ORIENTATION" value="TOP_TO_BOTTOM" />
							<y:Option name="GENERAL.SELECTED_ELEMENTS_INCREMENTALLY"
								value="false" />
							<y:Option name="EDGE_SETTINGS.EDGE_ROUTING" value="ORTHOGONAL" />
							<y:Option name="SWIMLANES." value="ORTHOGONAL" />
							<y:Option name="VISUAL.MINIMAL_NODE_DISTANCE" value="20.0" />
							<y:Option name="ALGORITHM.ACTIVATE_DETERMINISTIC_MODE"
								value="false" />
							<y:Option name="VISUAL.SCOPE" value="ALL" />
						</y:Processor>
					</y:Postprocessors>
				</data>
			</graph>
		</graphml>
	</xsl:template>
	<xsl:template match="//*" mode="create-nodes">
		<xsl:element name="node">
			<xsl:attribute name="id">
        <xsl:value-of select="@label" />
      </xsl:attribute>
			<data key="d0">
				<y:GenericNode configuration="DemoDefaults#Node">
					<y:Fill color="#FF9900" transparent="false" />
					<y:BorderStyle type="line" width="1.0" hasColor="false" />
					<y:NodeLabel>
						<xsl:value-of select="@label" />
					</y:NodeLabel>
				</y:GenericNode>
			</data>
		</xsl:element>
	</xsl:template>
	<xsl:template match="//*" mode="create-edges">
		<xsl:element name="edge">
			<xsl:attribute name="id">
        <xsl:value-of select="generate-id()" />
      </xsl:attribute>
			<xsl:attribute name="source">
        <xsl:value-of select="./atom[1]/@label" />
      </xsl:attribute>
			<xsl:attribute name="target">
        <xsl:value-of select="./atom[last()]/@label" />
      </xsl:attribute>
			<data key="d1">
				<y:PolyLineEdge>
					<xsl:choose>
						<xsl:when test="../@label = $shiftUp">
							<y:LineStyle type="line" width="1.0" color="#ffee00" /> <!-- yellow -->
						</xsl:when>
						<xsl:when test="../@label = $gears">
							<y:LineStyle type="line" width="1.0" color="#0009ff" /> <!-- blue -->
						</xsl:when>
						<xsl:when test="../@label = $nextGear">
							<y:LineStyle type="line" width="1.0" color="00ff88" /> <!-- green -->
						</xsl:when>
						<xsl:when test="../@label = $powered">
							<y:LineStyle type="line" width="1.0" color="#ee00ff" /> <!-- magenta -->
						</xsl:when>
						<xsl:when test="../@label = $previousGear">
							<y:LineStyle type="line" width="1.0" color="#ff8d00" /> <!-- orange -->
						</xsl:when>
						<xsl:otherwise><y:LineStyle type="line" width="1.0" color="#FF0010" /></xsl:otherwise>
					</xsl:choose>
					<y:Arrows source="none" target="default" />
					<xsl:element name="y:EdgeLabel">
						<xsl:value-of select="../../@label" />
					</xsl:element>
				</y:PolyLineEdge>
			</data>
		</xsl:element>

	</xsl:template>
</xsl:stylesheet>
