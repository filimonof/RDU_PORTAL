<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageNoAjax.master" AutoEventWireup="true" 
CodeFile="Programs.aspx.cs" Inherits="Programs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderWorkspace" Runat="Server">
    Ссылки на программы и программные комплексы Мордовского РДУ <br /> 
    в данном списке представлены программы запускаемые из браузера или сеетвые версии<br />
    <br />
    <a href="http://172.23.84.71">ПК Заявки</a><br />
    <a href="http://172.23.84.71/mrdu/">ПК Заявки Мордовское РДУ</a><br />
    <br />
    <a href="http://rds-mrdv/mrdu_test/index.html">ПК Ремонты (тестовая)</a><br />
    <a href="http://rds-mrdv/zvk6_mrdu_test/index.html">ПК Заявки v6 (тестовая)</a><br />
    <br />
    <a href="http://172.23.84.71/mrdu_kongo/">ПК КОННГО</a><br />
    <br />
    <a href="http://brc-mrdv/energostat">ИСП - Иерархическая система прог-нозирования электропотребления для краткосрочного планирования режимов ЕЭС</a><br />
    <br />
    <a href="\\gecon-mrdv\gecon1\client\go.exe">ГеКон Клиент Контур 1</a><br />
    <a href="\\gecon-mrdv\gecon1\admin\ga.exe">ГеКон Админ Контур 1</a><br />
    <a href="\\gecon-mrdv\gecon2\client\go.exe">ГеКон Клиент Контур 2</a><br />
    <a href="\\gecon-mrdv\gecon2\admin\ga.exe">ГеКон Админ Контур 2</a><br />
    <a href="\\gecon-mrdv\gecon1\client\doc\gecon_user_manual.pdf">ГеКон Клиент Документация</a><br />
    <br />    
    <a href="\\brc-mrdv\cfras\EXE\PPConsol\PPConsol.exe">Прогноз Потребления</a><br />
    <a href="\\br-mrdv\cfras\EXE\PPConsol\PPConsol.exe">Прогноз Потребления (тестовый)</a><br />
    <br />
    <a href="http://172.23.66.100/EnergySut/">Электроэнергия</a><br />
    <a href="O:\RABOTA\Toplivo">Топливо</a><br />
    <a href="o:\PROGRAMS\OBM_RDU\ObmRDU.exe ">ОБМ РДУ</a><br />  
    <br />
    <a href="O:\Report\new\Report.exe">Рапортичка</a><br />
    <a href="o:\m80020\m80020.exe">Макет 80020</a><br />  
    <a href="o:\ORE\WTE.exe ">ОРЕ</a><br />  
    <a href="O:\MMR\mmr.exe">MMR</a><br />
    <a href="o:\SystemPotreblenie\SysPotr.exe">Потребление системы (портянка)</a><br />  
    <a href="o:\PROGRAMS\Budka\Budka.exe ">Будка</a><br />  
    <br />   
    <a href=""></a><br />  
    <a href=""></a><br />  
    <a href=""></a><br />  

    <asp:Label ID="LabelPerf" runat="server" Text=""></asp:Label>

    
    

</asp:Content>

