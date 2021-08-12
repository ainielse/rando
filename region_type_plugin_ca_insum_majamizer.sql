prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_210100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.0'
,p_default_workspace_id=>319127834218171582
,p_default_application_id=>187
,p_default_id_offset=>337111644359196149
,p_default_owner=>'ANTON2'
);
end;
/
 
prompt APPLICATION 187 - THEE Full-On Clone
--
-- Application Export:
--   Application:     187
--   Name:            THEE Full-On Clone
--   Date and Time:   15:05 Thursday August 12, 2021
--   Exported By:     ANTON
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 342422846272036269
--   Manifest End
--   Version:         21.1.0
--   Instance ID:     248215807746919
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/region_type/ca_insum_majamizer
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(342422846272036269)
,p_plugin_type=>'REGION TYPE'
,p_name=>'CA.INSUM.MAJAMIZER'
,p_display_name=>'Majamizer'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- get the URL that includes APEX_CLONE_SESSION',
'-- note: currently does NOT support friendly URLs',
'function get_clone_url return varchar2 as',
'',
'    -- l_query_string will include everything after f? (e.g. p=123:44:32438298653:::RP:P44_ID:%5C9999%5C&cs=3iasdfufda923223dja93)',
'    l_query_string  varchar2(4000) := owa_util.get_cgi_env(''QUERY_STRING'');',
'    l_url           varchar2(4000);',
'    l_third_position    number;',
'',
'begin',
'',
'   htp.p(''l_query_string: '' || l_query_string);',
'',
'    -- throw away the checksum',
'    l_query_string := regexp_replace(l_query_string, ''&cs=(.*)'', null);',
'',
'    -- APEX converts \ to %5C in URLs. Change %5C back to \.',
'    l_query_string := replace(l_query_string, ''%5C'', ''\'');',
'',
'    -- Commas need to change back from %2C to ,.',
'    l_query_string := replace(l_query_string, ''%2C'', '','');',
'',
'     -- Spaces need to change back from + to a space.',
'    l_query_string := replace(l_query_string, ''+'', '' '');   ',
'',
'    -- if :REQUEST is not null, throw it away as we assum it has already done what it should do',
'    if :REQUEST is not null then',
'      l_query_string := replace(l_query_string, '':'' || :REQUEST ||'':'', ''::''); ',
'    end if;',
'',
'    -- inject APEX_CLONE_SESSION',
'    -- find the third colon and add APEX_CLONE_SESSION',
'    ',
'    l_third_position := instr(l_query_string, '':'', 1, 3);',
'    ',
'    -- inject APEX_CLONE_SESSION and add the checksum using apex_util.prepare_url',
'    l_url := apex_util.prepare_url(',
'                ''f?'' || substr(l_query_string, 1, l_third_position) ',
'                || ''APEX_CLONE_SESSION'' || substr(l_query_string, l_third_position + 1)',
'            );',
'',
'    return l_url;',
'end get_clone_url;',
'',
'--',
'--',
'-- main render function',
'function majamizer',
'  ( p_region              in apex_plugin.t_region',
'  , p_plugin              in apex_plugin.t_plugin',
'  , p_is_printer_friendly in boolean',
'  )',
'return apex_plugin.t_region_render_result',
'as',
'    l_result        apex_plugin.t_region_render_result;',
'',
'    --attributes',
'    l_attribute1    p_region.attribute_01%type := p_region.attribute_01;',
'    l_attribute2    p_region.attribute_02%type := p_region.attribute_02;',
'    l_attribute3    p_region.attribute_03%type := p_region.attribute_03;',
'',
'    l_region_id     p_region.static_id%type    := p_region.static_id;',
'    l_ajax_id       p_region.static_id%type    := apex_plugin.get_ajax_identifier;',
'',
'    --perform escaping',
'    l_region_id_esc p_region.static_id%type    := apex_escape.html_attribute(l_region_id);',
'',
'begin',
'',
'    --debug',
'    if apex_application.g_debug ',
'    then',
'        apex_plugin_util.debug_region',
'          ( p_plugin => p_plugin',
'          , p_region => p_region',
'          );',
'    end if;',
'',
'    if apex_page.get_page_mode(:APP_ID, :APP_PAGE_ID) = ''NORMAL'' then',
'',
'        htp.p(''',
'<script>',
'',
'// reload the page if in a new window or tab',
'if (window.name == null || window.name == "") {',
'    window.name = "NEW_SESSION";',
'    window.location.replace("'' || get_clone_url ||''");',
'}',
'',
'// after reloading the page, set the window name to be the APEX session',
'else if (window.name == "NEW_SESSION"){',
'    window.name = "&APP_SESSION.";',
'}',
'</script>    ',
''');',
'',
'    end if;',
'    ',
'    return l_result;',
'end majamizer;'))
,p_api_version=>2
,p_render_function=>'majamizer'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This region detects if window.name is null or "". If so, the region causes the page to reload with a new APEX session, using APEX_CLONE_SESSION. When the window reloads, this plug-in sets window.name to the new session ID. This plug-in can be used'
||' on Page 0 to always create a new session when a page is opened in a new tab.</p>',
'<p>*** The login page should have an "After Page Load" dynamic action (Execute JavaScript Code) that sets the window name to the APEX session ID.*** ',
'<pre>',
'window.name = "&APP_SESSION.";',
'</pre>',
'</p>',
'<p>*** This region should be placed in "Page Header" and have a template of "Blank with Attributes (No Grid)." This placement causes the page to reload prior to rendering any content.***</p> ',
'<p>*** This region should have a Server Side Condition that excludes the login page. *** </p>',
'<p>*** Note: This plug-in does NOT support friendly URLs.</p>',
'<p>*** If :REQUEST is not null, the value will be replaced with APEX_CLONE_SESSION. Pages that have :REQUEST not null will create a new session but the REQUEST value will not be passed to the new session. Hence, the page will run once in the current '
||'session with the REQUEST value passed on the URL. It will then reload in a new session without passing the REQUEST value to the new session.***</p>'))
,p_version_identifier=>'0.1'
,p_plugin_comment=>'This plug-in could have been created as a dynamic action plug-in to be used On Page Load. On Page Load dynamic actions, however, run after the page fully renders. By implementing this as a region plug-in and placing it in the Page Header region locat'
||'ion, the page reloads prior to rendering anything. Please see the Help Text for additional plug-in considerations. This plug-in attempts to clean up the URL, but many special characters are not handled. It is advisable to only pass numbers on the URL'
||' when using this plug-in.'
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
