prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.1'
,p_default_workspace_id=>25350112139807754752
,p_default_application_id=>210197
,p_default_id_offset=>0
,p_default_owner=>'WKSP_FLOWSMS'
);
end;
/
 
prompt APPLICATION 210197 - Kscope23 - Start your project the right way
--
-- Application Export:
--   Application:     210197
--   Name:            Kscope23 - Start your project the right way
--   Date and Time:   18:45 Thursday July 6, 2023
--   Exported By:     ANTON
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 27252331521336698804
--   Manifest End
--   Version:         23.1.1
--   Instance ID:     63113759365424
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/template_component/breadcrumb_from_nav_bar
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(27252331521336698804)
,p_plugin_type=>'TEMPLATE COMPONENT'
,p_theme_id=>nvl(wwv_flow_application_install.get_theme_id, '')
,p_name=>'BREADCRUMB_FROM_NAV_BAR'
,p_display_name=>'Breadcrumb from Nav Bar'
,p_supported_component_types=>'PARTIAL:REPORT'
,p_css_file_urls=>'#PLUGIN_FILES#bcfnb#MIN#.css'
,p_partial_template=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{case THE_LEVEL/}',
'{when 1/}',
'<h1 class="t-Breadcrumb-label bc-is-active" >#THE_LABEL#</h1>',
'{otherwise/}',
'<a href="#THE_TARGET#" class="t-Breadcrumb-label">#THE_LABEL#</a>',
'{endcase/}'))
,p_default_escape_mode=>'HTML'
,p_translate_this_template=>false
,p_api_version=>2
,p_report_body_template=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-BreadcrumbRegion-top">',
'<div class="t-BreadcrumbRegion-buttons t-BreadcrumbRegion-buttons--start">    ',
'<div class="t-BreadcrumbRegion-body">',
' <div class="t-BreadcrumbRegion-breadcrumb">',
'    <ul class="t-Breadcrumb ">#APEX$ROWS#</ul>',
'</div>',
'</div>',
'</div>',
'</div>'))
,p_report_row_template=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<li #APEX$ROW_IDENTIFICATION# class="t-Breadcrumb-item " aria-current="page">#APEX$PARTIAL#</li>',
'',
''))
,p_report_placeholder_count=>3
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Use this query:<br /><pre>',  
'with my_list as (',
'select plist.list_entry_id,',
'       plist.entry_text  label,',
'       plist.ENTRY_TARGET   entry_target,',
'       plist.ENTRY_TARGET   target,',
'       plist.list_entry_parent_id,',
'       null is_current_list_entry,',
'       plist.ENTRY_IMAGE   image,',
'       plist.ENTRY_IMAGE_ATTRIBUTES   image_attribute,',
'       plist.ENTRY_IMAGE_ALT_ATTRIBUTE   image_alt_attribute,',
'       plist.ENTRY_ATTRIBUTE_01   attribute1,',
'       plist.ENTRY_ATTRIBUTE_02   attribute2,',
'       plist.ENTRY_ATTRIBUTE_03   attribute3,',
'       plist.ENTRY_ATTRIBUTE_04   attribute4,',
'       plist.ENTRY_ATTRIBUTE_05   attribute5,',
'       plist.ENTRY_ATTRIBUTE_06   attribute6,',
'       plist.ENTRY_ATTRIBUTE_07   attribute7,',
'       plist.ENTRY_ATTRIBUTE_08   attribute8,',
'       plist.ENTRY_ATTRIBUTE_09   attribute9,',
'       plist.ENTRY_ATTRIBUTE_10   attribute10',
'    from apex_application_list_entries plist ',
'    left outer join APEX_APPLICATION_BUILD_OPTIONS cbo -- child build option',
'      on (cbo.build_option_name = plist.build_option',
'          and cbo.application_id = plist.application_id)  ',
'    where plist.application_id = :APP_TRANSLATION_ID',
'      and plist.list_name = ''Navigation Menu''',
'      and insum_menu_util.is_component_used_yn (',
'                p_build_option_id           => cbo.build_option_id,',
'                p_authorization_scheme_id   => plist.authorization_scheme_id,',
'                p_condition_type            => plist.condition_type_code,',
'                p_condition_expression1     => plist.condition_expression1,',
'                p_condition_expression2     => plist.condition_expression2) = ''Y'' ',
')            ',
'  select level the_level, ',
'         my_list.label,',
'         apex_util.prepare_url(apex_plugin_util.replace_substitutions (',
'                              p_value => my_list.target )) target ',
'    from my_list',
'    start with ( ',
'           my_list.entry_target like  ''f?p=&'' || ''APP_ID'' ||''.:'' || :app_page_id || '':%''',
'        or my_list.entry_target like  ''f?p='' || :APP_ALIAS || '':'' || :app_page_id || '':%''',
'        or my_list.entry_target like  ''f?p='' || lower(:APP_ALIAS)  || '':'' || :app_page_id || '':%''',
'        or my_list.entry_target like  ''f?p='' || :APP_ID || '':'' || :app_page_id || '':%''                 ',
'        )    ',
'    connect by nocycle  my_list.list_entry_id = prior my_list.list_entry_parent_id   ',
'    order by level desc',
'</pre>'))
,p_version_identifier=>'1.0'
,p_files_version=>6
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(27252331833693698810)
,p_plugin_id=>wwv_flow_imp.id(27252331521336698804)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_static_id=>'THE_LABEL'
,p_prompt=>'The Label'
,p_attribute_type=>'SESSION STATE VALUE'
,p_is_required=>false
,p_escape_mode=>'HTML'
,p_column_data_types=>'VARCHAR2'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(27252332204831698810)
,p_plugin_id=>wwv_flow_imp.id(27252331521336698804)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_static_id=>'THE_LEVEL'
,p_prompt=>'The Level'
,p_attribute_type=>'SESSION STATE VALUE'
,p_is_required=>false
,p_escape_mode=>'HTML'
,p_column_data_types=>'VARCHAR2'
,p_is_translatable=>false
,p_attribute_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with my_list as (',
'select plist.list_entry_id,',
'       plist.entry_text  label,',
'       plist.ENTRY_TARGET   entry_target,',
'       plist.ENTRY_TARGET   target,',
'       plist.list_entry_parent_id,',
'       null is_current_list_entry,',
'       plist.ENTRY_IMAGE   image,',
'       plist.ENTRY_IMAGE_ATTRIBUTES   image_attribute,',
'       plist.ENTRY_IMAGE_ALT_ATTRIBUTE   image_alt_attribute,',
'       plist.ENTRY_ATTRIBUTE_01   attribute1,',
'       plist.ENTRY_ATTRIBUTE_02   attribute2,',
'       plist.ENTRY_ATTRIBUTE_03   attribute3,',
'       plist.ENTRY_ATTRIBUTE_04   attribute4,',
'       plist.ENTRY_ATTRIBUTE_05   attribute5,',
'       plist.ENTRY_ATTRIBUTE_06   attribute6,',
'       plist.ENTRY_ATTRIBUTE_07   attribute7,',
'       plist.ENTRY_ATTRIBUTE_08   attribute8,',
'       plist.ENTRY_ATTRIBUTE_09   attribute9,',
'       plist.ENTRY_ATTRIBUTE_10   attribute10',
'    from apex_application_list_entries plist ',
'    left outer join APEX_APPLICATION_BUILD_OPTIONS cbo -- child build option',
'      on (cbo.build_option_name = plist.build_option',
'          and cbo.application_id = plist.application_id)  ',
'    where plist.application_id = :APP_TRANSLATION_ID',
'      and plist.list_name = ''Navigation Menu''',
'      and insum_menu_util.is_component_used_yn (',
'                p_build_option_id           => cbo.build_option_id,',
'                p_authorization_scheme_id   => plist.authorization_scheme_id,',
'                p_condition_type            => plist.condition_type_code,',
'                p_condition_expression1     => plist.condition_expression1,',
'                p_condition_expression2     => plist.condition_expression2) = ''Y'' ',
')            ',
'  select level the_level, ',
'         my_list.label,',
'         apex_util.prepare_url(apex_plugin_util.replace_substitutions (',
'                              p_value => my_list.target )) target ',
'    from my_list',
'    start with ( ',
'           my_list.entry_target like  ''f?p=&'' || ''APP_ID'' ||''.:'' || :app_page_id || '':%''',
'        or my_list.entry_target like  ''f?p='' || :APP_ALIAS || '':'' || :app_page_id || '':%''',
'        or my_list.entry_target like  ''f?p='' || lower(:APP_ALIAS)  || '':'' || :app_page_id || '':%''',
'        or my_list.entry_target like  ''f?p='' || :APP_ID || '':'' || :app_page_id || '':%''                 ',
'        )    ',
'    connect by nocycle  my_list.list_entry_id = prior my_list.list_entry_parent_id   ',
'    order by level desc'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(27252332643422698810)
,p_plugin_id=>wwv_flow_imp.id(27252331521336698804)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_static_id=>'THE_TARGET'
,p_prompt=>'The Target'
,p_attribute_type=>'SESSION STATE VALUE'
,p_is_required=>false
,p_escape_mode=>'HTML'
,p_column_data_types=>'VARCHAR2'
,p_is_translatable=>false
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '68312E742D42726561646372756D622D6C6162656C2E62632D69732D6163746976657B636F6C6F723A20766172282D2D75742D62726561646372756D622D6974656D2D6163746976652D746578742D636F6C6F72297D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(36188772846026354093)
,p_plugin_id=>wwv_flow_imp.id(27252331521336698804)
,p_file_name=>'bcfnb.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '68312E742D42726561646372756D622D6C6162656C2E62632D69732D6163746976657B636F6C6F723A766172282D2D75742D62726561646372756D622D6974656D2D6163746976652D746578742D636F6C6F72297D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(36190470235404878507)
,p_plugin_id=>wwv_flow_imp.id(27252331521336698804)
,p_file_name=>'bcfnb.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
