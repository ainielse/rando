create or replace procedure output_consolidated_help( p_app_id                  in number
                                  , p_list_name               in varchar2 default 'Desktop Navigation Menu'
                                  , p_show_help_regions       in varchar2 default 'Y'   -- show content of static regions with name like lower('%help%')
                                  , p_apply_authorizations    in varchar2 default 'Y'   -- N ignore authorizations and show all. Y apply authorizations.
                                  , p_apply_builds            in varchar2 default 'Y') -- N ignore build options and show all. Y only show Include build options.                       
is
--
--
-- Display all help associated with p_app_id and the navigation list p_list_name
-- using htp.p as the output
-- this is expected to be called by an APEX pl/sql region
-- if the list entry has an image/class that starts with fa- this routine will add <span class="fa [image/class]"></span>[item name]
-- First shows page help. The title is taken from the list, not the page title.
-- Then shows region text if p_show_help_regions = Y and region name like lower('%help')
-- Then shows item inline help followed by item help
-- For Regions and Items, condition_type is ignored UNLESS condition_type = Never, in which case it is not displayed
-- Authorizations and builds on the APEX list (p_list_name) are ignored
-- Authorizations and builds on the pages, regions, and items are controlled as described above

--l_scope               varchar2(2000) := gc_scope_prefix || 'output_consolidated_help';
--l_params              logger.tab_param;


l_page_id                 number;
l_start                   number;
l_end                     number;
l_title                   varchar2(256);
l_help                    varchar2(32767);
l_level                   number;
l_extra_help              varchar2(32767);
l_authorization_scheme    varchar2(4000);
l_build_option            varchar2(4000);

l_page_header             varchar2(4000);

l_count      number;


begin

--  logger.append_param(l_params, 'p_app_id', p_app_id);
--  logger.append_param(l_params, 'p_list_name', p_list_name);
--  logger.log('START', l_scope, null, l_params);
  
  -- base the order on the Navigation Menu
  for listRec in (
            select list_entry_id, list_entry_parent_id, apex_application.do_substitutions(entry_text) entry_text
                  , entry_target, display_sequence, entry_image
                  , level the_level
              from apex_application_list_entries
              where application_id = p_app_id
                and list_name = p_list_name
              start with list_entry_parent_id is null
              connect by prior list_entry_id = list_entry_parent_id
              order by display_sequence
              ) loop
  
    l_start := instr(listRec.entry_target,':');
    l_end   := instr(listRec.entry_target,':', 1, 2);
    l_page_id := substr(listRec.entry_target, l_start + 1, l_end - l_start - 1 );


    select page_title, help_text, authorization_scheme, build_option
      into l_title, l_help, l_authorization_scheme, l_build_option
      from apex_application_pages 
      where page_id = l_page_id
        and application_id = p_app_id;
        
    -- skip for auth check    
    if p_apply_authorizations = 'Y' and not APEX_AUTHORIZATION.IS_AUTHORIZED(p_authorization_name => l_authorization_scheme) then
      continue;
    end if;
    
    -- skip for build check
    if p_apply_builds = 'Y' and APEX_UTIL.GET_BUILD_OPTION_STATUS(p_application_id  => p_app_id, p_build_option_name => l_build_option) = 'EXCLUDE' then
      continue;
    end if;
    
    if listRec.the_level <= 3 then 
      l_level := listRec.the_level;
    else
      l_level := 3;
    end if;
    
    if listRec.entry_image like 'fa-%' then
      l_page_header := '<span class="fa ' || listRec.entry_image || '"></span>' || listRec.entry_text;
    else
      l_page_header := listRec.entry_text;
    end if;
    
    htp.p('<h' || l_level ||'>' || l_page_header || '</h' || l_level ||'>');
      
    if trim(l_help) not like '<p>%' then
      l_help := '<p>' || l_help || '</p>';
    end if;
      
    htp.p(l_help);      

    
--    l_extra_help := get_env_var(p_var_name  => 'FDM_P' || l_page_id ||'_HELP');
  
--    if l_extra_help is not null then
--      htp.p(l_extra_help);
--    end if;


    for regionRec in (
          select apr.region_id, apex_application.do_substitutions(apr.region_name) region_name, apr.region_source, apr.source_type_code
               , apr.authorization_scheme apr_auth_scheme, apr.build_option_id apr_build_id
               , (select count(*)
                    from apex_application_page_items api
                    where api.region_id = apr.region_id
                      and (p_apply_builds != 'Y' 
                          or api.build_option_id is null
                          or APEX_UTIL.GET_BUILD_OPTION_STATUS(p_application_id  => p_app_id, p_id => api.build_option_id) = 'INCLUDE')   
                      and (api.condition_type is null or api.condition_type != 'Never')
                      and (api.item_help_text is not null or  api.inline_help_text is not null)
                  ) ct_of_items   -- does not apply authorizations
            from apex_application_page_regions apr 
            where apr.page_id = l_page_id
              and apr.application_id = p_app_id 
              --and (p_apply_authorizations != 'Y' or APEX_AUTHORIZATION.IS_AUTHORIZED(p_authorization_name => apr.authorization_scheme))
              and (p_apply_builds != 'Y' 
                  or apr.build_option_id is null 
                  or APEX_UTIL.GET_BUILD_OPTION_STATUS(p_application_id  => p_app_id, p_id => apr.build_option_id) = 'INCLUDE')
              and (apr.condition_type is null or apr.condition_type != 'Never')
            order by apr.display_sequence    
            ) loop

      -- skip for region auth check  
      if p_apply_authorizations = 'Y' and not APEX_AUTHORIZATION.IS_AUTHORIZED(p_authorization_name => regionRec.apr_auth_scheme)  then
        continue;
      end if;
      
      -- check to see if this is a "help" region or if it has items
      if regionRec.ct_of_items = 0 
           and (nvl(lower(regionRec.region_name),'x') not like '%help%'
              or regionRec.source_type_code != 'STATIC_TEXT') then
        continue;
      end if;
        
      -- show the region and its items
      htp.p('<h4>' || regionRec.region_name ||  '</h4>');
      
      if lower(regionRec.region_name) like '%help%' and regionRec.source_type_code = 'STATIC_TEXT' then
        htp.p(regionRec.region_source);
      end if;
          
      -- show item help
      l_count := 0;
    
      for itemRec in (
          select api.item_id
               , apex_application.do_substitutions(api.label) item_label, api.item_help_text, api.inline_help_text, api.display_sequence
               , api.authorization_scheme, api.build_option_id
            from apex_application_page_items api 
            where api.region_id = regionRec.region_id
              and (api.item_help_text is not null or  api.inline_help_text is not null)
              --and (p_apply_authorizations != 'Y' or APEX_AUTHORIZATION.IS_AUTHORIZED(p_authorization_name => api.authorization_scheme))
              and (p_apply_builds != 'Y' 
                  or api.build_option_id is null
                  or APEX_UTIL.GET_BUILD_OPTION_STATUS(p_application_id  => p_app_id, p_id => api.build_option_id) = 'INCLUDE')   
              and (api.condition_type is null or api.condition_type != 'Never')
            order by api.display_sequence
            ) loop
          
        -- skip for region auth check  
        if p_apply_authorizations = 'Y' and not APEX_AUTHORIZATION.IS_AUTHORIZED(p_authorization_name => itemRec.authorization_scheme)  then
          continue;
        end if;
          
        l_count := l_count + 1;     
        
        if l_count = 1 then  -- first row
          htp.p('<h5>Region Items</h5>');
          htp.p('<ul>');  
        end if;  
         
        htp.p('<li><strong>' || itemRec.item_label ||':</strong> '|| itemRec.inline_help_text||' '|| itemRec.item_help_text ||'</li>');   
          
      end loop; -- items
      
      if l_count > 0 then
        htp.p('</ul>');
      end if;  
    end loop; -- regions  
    
    htp.p('<hr />');
  end loop; -- pages   

--  logger.log('END', l_scope, null);
end output_consolidated_help;

