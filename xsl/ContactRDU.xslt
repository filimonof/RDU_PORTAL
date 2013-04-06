<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  
  <xsl:param name="field_sort" />
  <xsl:param name="first_letter_name" />
  <xsl:param name="name_departament" />
  
  <xsl:template match="/">
    <xsl:element name="Contacts">
      <!--по подразделению-->
      <xsl:if test="string-length($name_departament) != 0">
        <xsl:apply-templates select="RDU_Contacts/departament[@name=$name_departament]/contact">
          <xsl:sort select="@*[name() = $field_sort]" data-type="text" />
        </xsl:apply-templates>
      </xsl:if>
      <!--по первым буквам имени-->
      <xsl:if test="string-length($first_letter_name) != 0">
        <xsl:apply-templates select="RDU_Contacts/departament/contact[starts-with(@name,$first_letter_name)]" >
          <xsl:sort select="@*[name() = $field_sort]" data-type="text" />
        </xsl:apply-templates>
      </xsl:if>
      <!--без параметров выводим весь список-->
      <xsl:if test="string-length($first_letter_name) = 0 and string-length($name_departament) = 0">
        <xsl:apply-templates select="RDU_Contacts/departament/contact" >
          <xsl:sort select="@*[name() = $field_sort]" data-type="text" />
        </xsl:apply-templates>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <!--ноду contact копируем без изменений-->
  <xsl:template match="contact">
    <xsl:copy-of select="."/>
  </xsl:template>

  <!--стандартный шаблон нах не нужен
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  -->

</xsl:stylesheet>
