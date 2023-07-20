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
,p_default_workspace_id=>113067632160437694
,p_default_application_id=>238295
,p_default_id_offset=>0
,p_default_owner=>'ANTON'
);
end;
/
 
prompt APPLICATION 238295 - AIT114
--
-- Application Export:
--   Application:     238295
--   Name:            AIT114
--   Date and Time:   17:00 Thursday July 20, 2023
--   Exported By:     ANTON
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 41102684474522359831
--   Manifest End
--   Version:         23.1.1
--   Instance ID:     63113759365424
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/region_type/super_breadcrumb
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(41102684474522359831)
,p_plugin_type=>'REGION TYPE'
,p_name=>'SUPER_BREADCRUMB'
,p_display_name=>'Super Breadcrumb'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function do_substitutions(  p_string        in varchar,',
'                            p_name          in varchar2,',
'                            p_link          in varchar2,',
'                            p_css_classes   in varchar2 default null) return varchar2 is',
'l_new_string    varchar2(32767) := p_string;',
'begin',
'    l_new_string := replace(l_new_string, ''#NAME#'', p_name);',
'    l_new_string := replace(l_new_string, ''#LINK#'', p_link);',
'    l_new_string := replace(l_new_string, ''#COMPONENT_CSS_CLASSES#'', p_css_classes);',
'',
'    return l_new_string;',
'end;',
'--',
'--',
'function render_from_nav_menu(',
'                p_region              in apex_plugin.t_region,',
'                p_plugin              in apex_plugin.t_plugin,',
'                p_is_printer_friendly in boolean ) return apex_plugin.t_region_render_result is',
'',
'    l_additional_items  varchar2(32767) := p_region.ajax_items_to_submit;',
'    c_region_static_id  constant varchar2(255)  := apex_escape.html_attribute( p_region.static_id );',
'',
'',
'    l_max_levels        p_region.attribute_01%type := p_region.attribute_01;',
'    l_nav_or_collection p_region.attribute_02%type := p_region.attribute_02;',
'    l_css_classes       p_region.attribute_04%type := p_region.attribute_04;',
'  ',
'    l_bc_rec            apex_application_temp_bc%rowtype;',
'    l_target            varchar2(4000);',
'',
'begin',
'',
'    --debug',
'    if apex_application.g_debug then',
'        apex_debug.message(''Super Breadcrumb: render_from_nav_menu'');',
'    end if;',
'',
'    select bc.*',
'      into l_bc_rec',
'      from apex_application_themes theme',
'      join apex_application_templates temp',
'        on temp.theme_number = theme.theme_number  ',
'        and temp.application_id = theme.application_id',
'      join apex_application_temp_bc bc ',
'        on bc.breadcrumb_template_id = temp.template_id',
'      where theme.application_id = :APP_TRANSLATION_ID',
'        and temp.internal_name = ''BREADCRUMB''',
'        and temp.is_default = ''Yes'';',
'',
'    sys.htp.p(do_substitutions( p_string        =>  l_bc_rec.before_first,',
'                            p_name          => null,',
'                            p_link          => null,',
'                            p_css_classes   => l_css_classes)',
'                        );',
'',
'    for page_rec in (',
'        with my_list as (',
'        select plist.list_entry_id,',
'               plist.entry_text  label,',
'               plist.ENTRY_TARGET   entry_target,',
'               plist.ENTRY_TARGET   target,',
'               plist.list_entry_parent_id,',
'               null is_current_list_entry,',
'               plist.ENTRY_IMAGE   image,',
'               plist.ENTRY_IMAGE_ATTRIBUTES   image_attribute,',
'               plist.ENTRY_IMAGE_ALT_ATTRIBUTE   image_alt_attribute,',
'               plist.ENTRY_ATTRIBUTE_01   attribute1,',
'               plist.ENTRY_ATTRIBUTE_02   attribute2,',
'               plist.ENTRY_ATTRIBUTE_03   attribute3,',
'               plist.ENTRY_ATTRIBUTE_04   attribute4,',
'               plist.ENTRY_ATTRIBUTE_05   attribute5,',
'               plist.ENTRY_ATTRIBUTE_06   attribute6,',
'               plist.ENTRY_ATTRIBUTE_07   attribute7,',
'               plist.ENTRY_ATTRIBUTE_08   attribute8,',
'               plist.ENTRY_ATTRIBUTE_09   attribute9,',
'               plist.ENTRY_ATTRIBUTE_10   attribute10,',
'               cbo.build_option_id,',
'               plist.authorization_scheme_id,',
'               plist.condition_type_code,',
'               plist.condition_expression1,',
'               plist.condition_expression2',
'            from apex_applications aa',
'            join apex_application_list_entries plist on plist.list_id = aa.navigation_list_id',
'            left outer join APEX_APPLICATION_BUILD_OPTIONS cbo -- child build option',
'              on (cbo.build_option_name = plist.build_option',
'                  and cbo.application_id = plist.application_id)  ',
'            where aa.application_id = :APP_TRANSLATION_ID',
'        )            ',
'          select level the_level, ',
'                 my_list.label,',
'                 my_list.target,',
'                 my_list.build_option_id,',
'                 my_list.authorization_scheme_id,',
'                 my_list.condition_type_code,',
'                 my_list.condition_expression1,',
'                 my_list.condition_expression2 ',
'            from my_list',
'            start with ( ',
'                   my_list.entry_target like  ''f?p=&'' || ''APP_ID'' ||''.:'' || :app_page_id || '':%''',
'                or my_list.entry_target like  ''f?p='' || :APP_ALIAS || '':'' || :app_page_id || '':%''',
'                or my_list.entry_target like  ''f?p='' || lower(:APP_ALIAS)  || '':'' || :app_page_id || '':%''',
'                or my_list.entry_target like  ''f?p='' || :APP_ID || '':'' || :app_page_id || '':%''                 ',
'                )    ',
'            connect by nocycle  my_list.list_entry_id = prior my_list.list_entry_parent_id   ',
'            order by level desc',
'        ) loop',
'',
'        l_target := apex_util.prepare_url(apex_plugin_util.replace_substitutions(p_value => page_rec.target ));',
'',
'        if apex_plugin_util.is_component_used (',
'                    p_build_option_id           => page_rec.build_option_id,',
'                    p_authorization_scheme_id   => page_rec.authorization_scheme_id,',
'                    p_condition_type            => page_rec.condition_type_code,',
'                    p_condition_expression1     => page_rec.condition_expression1,',
'                    p_condition_expression2     => page_rec.condition_expression2) then',
'            if page_rec.the_level = 1 then',
'                sys.htp.p(do_substitutions( p_string        => l_bc_rec.current_page_option,',
'                                        p_name          => page_rec.label,',
'                                        p_link          => l_target,',
'                                        p_css_classes   => l_css_classes));',
'            elsif page_rec.the_level <= to_number(l_max_levels) then',
'                sys.htp.p(do_substitutions( p_string        => l_bc_rec.non_current_page_option,',
'                                        p_name          => page_rec.label,',
'                                        p_link          => l_target,',
'                                        p_css_classes   => l_css_classes));',
'',
'                sys.htp.p(l_bc_rec.between_levels);',
'            end if;',
'        end if;    ',
'    end loop;    ',
'',
'    sys.htp.p(l_bc_rec.after_last);',
'',
'    return null;',
'',
'end render_from_nav_menu;          ',
'--',
'--',
'function render_from_collection(',
'                p_region              in apex_plugin.t_region,',
'                p_plugin              in apex_plugin.t_plugin,',
'                p_is_printer_friendly in boolean ) return apex_plugin.t_region_render_result is',
'',
'    l_additional_items  varchar2(32767) := p_region.ajax_items_to_submit;',
'    c_region_static_id  constant varchar2(255)  := apex_escape.html_attribute( p_region.static_id );',
'',
'',
'    l_max_levels        p_region.attribute_01%type := p_region.attribute_01;',
'    l_nav_or_collection p_region.attribute_02%type := p_region.attribute_02;',
'    l_collection_name   p_region.attribute_03%type := p_region.attribute_03;',
'    l_css_classes       p_region.attribute_04%type := p_region.attribute_04;',
'    l_rewind_method     p_region.attribute_05%type := p_region.attribute_05;',
'    l_no_rewind_page_list  p_region.attribute_06%type := p_region.attribute_06;',
'    l_max_seq_id        number;',
'    l_latest_app_id     number;',
'    l_latest_page_id    number;',
'    l_latest_title      varchar2(4000);',
'    l_show_latest_page  boolean := true;',
'    l_minus_if_reload   number := 0;',
'  ',
'    l_bc_rec            apex_application_temp_bc%rowtype;',
'    l_target            varchar2(4000);',
'    l_title             varchar2(4000);',
'    l_page_mode         varchar2(4000);',
'    l_rewind_id         number;',
'',
'    l_javascript        clob :=',
'''',
'apex.server.plugin (',
'    "'' || apex_plugin.get_ajax_identifier ||''"',
'    ,{',
'    x01: window.location,',
'    x02: document.title,',
'    }',
'    );',
''';    ',
'',
'begin',
'',
'    --debug',
'    if apex_application.g_debug then',
'        apex_debug.message(''Super Breadcrumb: render_from_nav_menu'');',
'    end if;',
'',
'    select page_mode',
'      into l_page_mode ',
'      from apex_application_pages p',
'      where p.application_id = :APP_ID',
'        and p.page_id = :APP_PAGE_ID;',
'',
'    if l_page_mode = ''Normal'' then',
'        ',
'        -- current page',
'        select ap.page_title',
'          into l_title',
'          from apex_application_pages ap ',
'          where ap.application_id = :APP_TRANSLATION_ID',
'            and ap.page_id = :APP_PAGE_ID;    ',
'',
'        l_title := apex_plugin_util.replace_substitutions (p_value => l_title);  ',
'',
'        apex_debug.message(''Super Breadcrumb %s: %s'', ''l_title'', l_title);  ',
'',
'        begin',
'            select max(seq_id)    ',
'              into l_max_seq_id',
'              from apex_collections ac',
'              where ac.collection_name = l_collection_name;',
'        exception when no_data_found then null;',
'        end;      ',
'',
'        if l_max_seq_id is not null then ',
'',
'            apex_debug.message(''Super Breadcrumb %s: %s'', ''l_max_seq_id'', l_max_seq_id);',
'              ',
'            select c002     link_label,',
'                   n001     app_id,',
'                   n002     page_id',
'              into l_latest_title,',
'                   l_latest_app_id,',
'                   l_latest_page_id',
'              from apex_collections ac',
'              where ac.collection_name = l_collection_name',
'                and ac.seq_id = l_max_seq_id;',
'',
'            if l_latest_app_id = :APP_ID and l_latest_page_id = :APP_PAGE_ID and l_latest_title = l_title then',
'                -- in this case the user like hit refresh, don''t show the same page again   ',
'                l_show_latest_page := false;',
'                -- subtract one from the level number on a reload',
'                l_minus_if_reload := 1;',
'            end if;  ',
'        end if;       ',
'',
'        -- rewind',
'        if l_rewind_method != ''DO_NOT_REWIND'' ',
'            and instr('','' || l_no_rewind_page_list ||'',''  ,'','' ||:APP_PAGE_ID ||'','' )  = 0',
'            then    ',
'            if l_rewind_method = ''PAGE_AND_TITLE'' then',
'                begin',
'                    select min(seq_id)',
'                      into l_rewind_id',
'                      from apex_collections',
'                      where collection_name = l_collection_name',
'                        and n001 = :APP_ID',
'                        and n002 = :APP_PAGE_ID',
'                        and c002 = l_title;    ',
'                exception when no_data_found then null;',
'                end;     ',
'            elsif l_rewind_method = ''PAGE'' then',
'                begin',
'                    select min(seq_id)',
'                      into l_rewind_id',
'                      from apex_collections',
'                      where collection_name = l_collection_name',
'                        and n001 = :APP_ID',
'                        and n002 = :APP_PAGE_ID;    ',
'                exception when no_data_found then null;',
'                end;   ',
'            end if;',
'',
'            if l_rewind_id is not null then',
'                for rewind in (select seq_id from apex_collections',
'                                where collection_name = l_collection_name',
'                                  and seq_id >= l_rewind_id) loop',
'                    apex_collection.delete_member(',
'                        p_collection_name   => l_collection_name,',
'                        p_seq               => rewind.seq_id);',
'                end loop;  ',
'            end if; ',
'        end if;        ',
'        -- end rewind',
'',
'        select bc.*',
'          into l_bc_rec',
'          from apex_application_themes theme',
'          join apex_application_templates temp',
'            on temp.theme_number = theme.theme_number  ',
'            and temp.application_id = theme.application_id',
'          join apex_application_temp_bc bc ',
'            on bc.breadcrumb_template_id = temp.template_id',
'          where theme.application_id = :APP_TRANSLATION_ID',
'            and temp.internal_name = ''BREADCRUMB''',
'            and temp.is_default = ''Yes'';',
'',
'        sys.htp.p(do_substitutions( p_string        =>  l_bc_rec.before_first,',
'                            p_name          => null,',
'                            p_link          => null,',
'                            p_css_classes   => l_css_classes)',
'                        );',
'',
'        for page_rec in (',
'            select c001     link_target,',
'                   c002     link_label,',
'                   n001     app_id,',
'                   n002     page_id,',
'                   row_number() over (order by seq_id desc) rn,',
'                   seq_id',
'              from apex_collections ac',
'              where ac.collection_name = l_collection_name ',
'              order by seq_id',
'            ) loop',
'',
'            if page_rec.rn - l_minus_if_reload < l_max_levels then',
'                if page_rec.seq_id != l_max_seq_id or l_show_latest_page then',
'                    sys.htp.p(do_substitutions( p_string     => l_bc_rec.non_current_page_option,',
'                                                p_name       => page_rec.link_label,',
'                                                p_link       => page_rec.link_target,',
'                                                p_css_classes   => l_css_classes));',
'',
'                    sys.htp.p(l_bc_rec.between_levels);',
'                end if;    ',
'            end if;',
'        end loop;    ',
'        ',
'        sys.htp.p(do_substitutions( p_string     => l_bc_rec.current_page_option,',
'                                p_name       => l_title,',
'                                p_link       => null,',
'                                p_css_classes   => l_css_classes));',
'',
'        sys.htp.p(l_bc_rec.after_last);',
'',
'        apex_javascript.add_onload_code (p_code => l_javascript);',
'    end if; -- it is a Normal page',
'',
'    return null;',
'',
'end render_from_collection;          ',
'--',
'--',
'function render (p_region              in apex_plugin.t_region,',
'                 p_plugin              in apex_plugin.t_plugin,',
'                 p_is_printer_friendly in boolean ) return apex_plugin.t_region_render_result is',
'',
'    l_result            apex_plugin.t_region_render_result;',
'',
'    l_additional_items  varchar2(32767) := p_region.ajax_items_to_submit;',
'    c_region_static_id  constant varchar2(255)  := apex_escape.html_attribute( p_region.static_id );',
'',
'    l_nav_or_collection p_region.attribute_02%type := p_region.attribute_02;',
'',
'begin',
'',
'    --debug',
'    if apex_application.g_debug then',
'        apex_plugin_util.debug_region (p_plugin => p_plugin,',
'                                       p_region => p_region ',
'        );',
'    end if;',
'',
'    if l_nav_or_collection = ''NAV'' then',
'        l_result := render_from_nav_menu(',
'                    p_region              => p_region,',
'                    p_plugin              => p_plugin,',
'                    p_is_printer_friendly => p_is_printer_friendly);',
'    elsif l_nav_or_collection = ''COLLECTION'' then   ',
'        l_result := render_from_collection(',
'                    p_region              => p_region,',
'                    p_plugin              => p_plugin,',
'                    p_is_printer_friendly => p_is_printer_friendly);          ',
'    end if;                ',
'',
'',
'    return l_result;',
'',
'end render;',
'--',
'--',
'',
'function ajax  (p_region in apex_plugin.t_region,',
'                p_plugin in apex_plugin.t_plugin ) return apex_plugin.t_region_ajax_result is',
'',
'    l_url               varchar2(4000) := apex_application.g_x01;',
'    l_title             varchar2(4000) := apex_application.g_x02;',
'',
'    l_max_levels        p_region.attribute_01%type := p_region.attribute_01;',
'    l_nav_or_collection p_region.attribute_02%type := p_region.attribute_02;',
'    l_collection_name   p_region.attribute_03%type := p_region.attribute_03;',
'',
'    l_latest_url        varchar2(4000);',
'',
'begin',
'',
'    --debug',
'    if apex_application.g_debug then',
'        apex_plugin_util.debug_region (p_plugin => p_plugin,',
'                                       p_region => p_region);',
'    end if;',
'',
'    if not apex_collection.collection_exists(l_collection_name) then',
'        apex_collection.create_collection(l_collection_name);',
'    end if;',
'          ',
'    begin      ',
'        select c001',
'            into l_latest_url',
'          from apex_collections ac',
'          where ac.collection_name = l_collection_name',
'            and ac.seq_id = (select max(ac2.seq_id) ',
'                                from apex_collections ac2',
'                                where ac2.collection_name = l_collection_name );',
'    exception when no_data_found then null;',
'    end;                            ',
'',
'    if l_url != l_latest_url or l_latest_url is null then                        ',
'',
'        apex_collection.add_member(',
'            p_collection_name => l_collection_name,',
'            p_c001            => l_url,',
'            p_c002            => l_title,',
'            p_n001            => :APP_ID,',
'            p_n002            => :APP_PAGE_ID);',
'    end if;',
'',
'    --sys.htp.p(''{success: true}'');',
'    apex_json.open_object;',
'    apex_json.write(''success'', true);',
'    --apex_json.write(''x01'', apex_application.g_x01);',
'    apex_json.close_object;',
'',
'    return null;',
'',
'end ajax;   ',
''))
,p_default_escape_mode=>'HTML'
,p_api_version=>2
,p_render_function=>'render'
,p_ajax_function=>'ajax'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This region plug-in is optimized for use on page 0 (the global page). Place this in the breadcrumb location with a template of "Title Bar."</p>',
'<p>You may wish to only show the region on Normal (non-modal) pages and not on certain other pages. Consider using a Server Side Condition, type = "Function Body" with the following code:',
'<pre>',
'declare',
'',
'l_page_mode     varchar2(200);',
'begin',
'  select page_mode ',
'    into l_page_mode',
'    from apex_application_pages',
'    where application_id = :APP_ID',
'      and page_id = :APP_PAGE_ID;',
'',
'  return l_page_mode = ''Normal'' and :APP_PAGE_ID not in (9999); -- 9999 is the login page',
'end;',
'</pre>',
'</p>'))
,p_version_identifier=>'1.0'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(41113386826593585929)
,p_plugin_id=>wwv_flow_imp.id(41102684474522359831)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Max Levels'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'5'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Indicate the maximum levels to show.</p>',
'<p><strong>Note:</strong> This region plug-in is optimized for use on page 0 (the global page). Place this in the breadcrumb location with a template of "Title Bar."</p>',
'<p>You may wish to only show the region on Normal (non-modal) pages and not on certain other pages. Consider using a Server Side Condition, type = "Function Body" with the following code:',
'<pre>',
'declare',
'',
'l_page_mode     varchar2(200);',
'begin',
'  select page_mode ',
'    into l_page_mode',
'    from apex_application_pages',
'    where application_id = :APP_ID',
'      and page_id = :APP_PAGE_ID;',
'',
'  return l_page_mode = ''Normal'' and :APP_PAGE_ID not in (9999); -- 9999 is the login page',
'end;',
'</pre>',
'</p>'))
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41113392831200586914)
,p_plugin_attribute_id=>wwv_flow_imp.id(41113386826593585929)
,p_display_sequence=>10
,p_display_value=>'1'
,p_return_value=>'1'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41113890953397437497)
,p_plugin_attribute_id=>wwv_flow_imp.id(41113386826593585929)
,p_display_sequence=>20
,p_display_value=>'2'
,p_return_value=>'2'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41113399303970587647)
,p_plugin_attribute_id=>wwv_flow_imp.id(41113386826593585929)
,p_display_sequence=>30
,p_display_value=>'3'
,p_return_value=>'3'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41113402153818588033)
,p_plugin_attribute_id=>wwv_flow_imp.id(41113386826593585929)
,p_display_sequence=>40
,p_display_value=>'4'
,p_return_value=>'4'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41113402793536588392)
,p_plugin_attribute_id=>wwv_flow_imp.id(41113386826593585929)
,p_display_sequence=>50
,p_display_value=>'5'
,p_return_value=>'5'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41113902301934438939)
,p_plugin_attribute_id=>wwv_flow_imp.id(41113386826593585929)
,p_display_sequence=>60
,p_display_value=>'6'
,p_return_value=>'6'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41113903531239439385)
,p_plugin_attribute_id=>wwv_flow_imp.id(41113386826593585929)
,p_display_sequence=>70
,p_display_value=>'7'
,p_return_value=>'7'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41113413361052589634)
,p_plugin_attribute_id=>wwv_flow_imp.id(41113386826593585929)
,p_display_sequence=>80
,p_display_value=>'8'
,p_return_value=>'8'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41113905555209440208)
,p_plugin_attribute_id=>wwv_flow_imp.id(41113386826593585929)
,p_display_sequence=>90
,p_display_value=>'9'
,p_return_value=>'9'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41113909091914440926)
,p_plugin_attribute_id=>wwv_flow_imp.id(41113386826593585929)
,p_display_sequence=>100
,p_display_value=>'10'
,p_return_value=>'10'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41113427335521591143)
,p_plugin_attribute_id=>wwv_flow_imp.id(41113386826593585929)
,p_display_sequence=>110
,p_display_value=>'15'
,p_return_value=>'15'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41113922335071441873)
,p_plugin_attribute_id=>wwv_flow_imp.id(41113386826593585929)
,p_display_sequence=>120
,p_display_value=>'20'
,p_return_value=>'20'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41113924408615442524)
,p_plugin_attribute_id=>wwv_flow_imp.id(41113386826593585929)
,p_display_sequence=>130
,p_display_value=>'30'
,p_return_value=>'30'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41113444818928594216)
,p_plugin_attribute_id=>wwv_flow_imp.id(41113386826593585929)
,p_display_sequence=>140
,p_display_value=>'100 (really?)'
,p_return_value=>'100'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(41114389687182603418)
,p_plugin_id=>wwv_flow_imp.id(41102684474522359831)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Breadcrumb Source'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'NAV'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Indicate if the breadcrumb should be based upon the application navigation menu or the actual pages visited.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41115182331387610052)
,p_plugin_attribute_id=>wwv_flow_imp.id(41114389687182603418)
,p_display_sequence=>10
,p_display_value=>'Application Navigation Menu'
,p_return_value=>'NAV'
,p_help_text=>'The navigation menu defined in Application Definition > User Interface > Navigation Menu List'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41115581634429617475)
,p_plugin_attribute_id=>wwv_flow_imp.id(41114389687182603418)
,p_display_sequence=>20
,p_display_value=>'Page View History'
,p_return_value=>'COLLECTION'
,p_help_text=>'Pages viewed will be stored in the collection name defined below. This style will only render for Normal (non-modal) pages.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(41116054620254474637)
,p_plugin_id=>wwv_flow_imp.id(41102684474522359831)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Collection Name'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'INSUM_SUPER_BREADCRUMB'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(41114389687182603418)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'COLLECTION'
,p_help_text=>'Enter the name of the collection to store page view history.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(41121244810983544512)
,p_plugin_id=>wwv_flow_imp.id(41102684474522359831)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>15
,p_prompt=>'CSS Classes'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Add additional CSS classes. This will replace #COMPONENT_CSS_CLASSES# in the breadcrumb template.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(41242100786971334824)
,p_plugin_id=>wwv_flow_imp.id(41102684474522359831)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Rewind Style'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'PAGE_AND_TITLE'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(41114389687182603418)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'COLLECTION'
,p_lov_type=>'STATIC'
,p_help_text=>'Indicate if and how the breadcrumb should rewind.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41246707641976513592)
,p_plugin_attribute_id=>wwv_flow_imp.id(41242100786971334824)
,p_display_sequence=>5
,p_display_value=>'Never Rewind'
,p_return_value=>'DO_NOT_REWIND'
,p_help_text=>'Do not rewind. This will show the most recent n pages viewed where n is the "Max Levels" setting above.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41243037129904490164)
,p_plugin_attribute_id=>wwv_flow_imp.id(41242100786971334824)
,p_display_sequence=>10
,p_display_value=>'Matching Page ID and Title'
,p_return_value=>'PAGE_AND_TITLE'
,p_help_text=>'Rewind if the Page ID and title match anything in the tree.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(41248254581120539226)
,p_plugin_attribute_id=>wwv_flow_imp.id(41242100786971334824)
,p_display_sequence=>20
,p_display_value=>'Matching Page ID'
,p_return_value=>'PAGE'
,p_help_text=>'Rewind if the Page ID matches anything in the tree.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(41598759476778168728)
,p_plugin_id=>wwv_flow_imp.id(41102684474522359831)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Do Not Rewind Pages'
,p_attribute_type=>'PAGE NUMBERS'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(41242100786971334824)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_EQUALS'
,p_depending_on_expression=>'DO_NOT_REWIND'
,p_help_text=>'Enter a list of page IDs that will not rewind. For example, if you have a report and form, you may not want to rewind on the report.'
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
