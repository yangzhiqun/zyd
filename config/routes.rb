Rails.application.routes.draw do

  get 'log_management/index'
  get 'log_management/search'
  match 'config/init_site', via: [:get, :post]
  get 'site-logo' => 'config#site_logo'

  post 'sms_helper/send_msg'

  devise_for :users, controllers: {sessions: 'users/sessions', registrations: 'users/registrations'}

  match 'update-account' => 'users#update_account', via: [:get, :post]
  match 'fsnip/sso' => 'ca_helper#fsnip_sso', via: [:get, :post]
  match 'fsnip/logout' => 'ca_helper#fsnip_logout', via: [:get, :post]

  resources :jg_bsb_stamps do
    get 'cover'
  end
    get 'ca_helper/create_text' => 'ca_helper#create_text'
     get  'ca_helper/hash_client_sign' => 'ca_helper#hash_client_sign'
    get 'ca_helper/client_sign_pdf' => 'ca_helper#client_sign_pdf'
  post 'ca_helper/client_sign_pdf'
  get "ca_helper/verify_report"
  post "ca_helper/verify_report"
  resources :ca_helper do
    collection do
      get 'by_ca_info'
      get 'print_pdf'
    end
  end

  get "beica_sso" => 'ca_helper#sso'
	get "synchronize_info" => "ca_helper#account_sync"
  resources :xsbg_tt_data
  resources :xsbg_tts
  resources :sample_members do
    member do
      get 'portrait'
    end
  end

  resources :welcome_notices do
    member do
      get "attachment"
    end
  end

  resources :sp_bsb_publications do
    collection do
      get 'check_duplicate'
      post 'check_duplicate'

      get 'unpublished'
      get 'published'

      post 'publish_bsbs'
      post 'publish_bsbs_from_xls'
    end
    member do
      get 'show_publication'
    end
  end
  post "sp_bsb_publications_filtered" => "sp_bsb_publications#index"

  resources :company_standards do
    member do
      get "attachment"
    end
  end

  # 附件管理
  match "attachment/upload", :via => [:post, :patch]
  get "attachments/:id/download" => "attachment#download"
  get "attachments/:id/preview" => "attachment#preview"
  post "attachments/:id/destroy" => "attachment#destroy"
  delete "destroy_attachment" => "attachment#destroy"
  post 'tinymce_assets' => 'attachment#tinymce_upload'

  resources :baosong_as
  resources :baosong_bs do
    collection do
      get "by_name" => "baosong_bs#baosong_bs_by_name"
      get "by_cityname" => "baosong_bs#baosong_bs_by_cityname"
      get "by_rwly" => "baosong_bs#baosong_bs_by_rwly"
    end

    member do
      get "categories"
    end
  end

  resources :baosong_as_newests
  resources :baosong_bs_newests do
    collection do
      get "by_name" => "baosong_bs_newests#baosong_bs_by_name"
      get "by_cityname" => "baosong_bs_newests#baosong_bs_by_cityname"
      get "categories"
			get "check_items"
    end
  end

  # Category Helper Controller
  post 'category_batch_delete/:category' => 'category_helper#batch_delete'
  post 'create_category/:category' => 'category_helper#create'
  post 'update_category/:category' => 'category_helper#update'
	post  'create_categorys/:category'=> 'category_helper#batch_create'
	get  'query_category/:category'  => 'category_helper#query_categorys'

  resources :a_categories do
    collection do
      get "categories"
    end
  end

  get "a_categories_by_identifier" => "a_categories#by_identifier"
  get "b_categories_by_a_id" => "b_categories#by_id"
  get "c_categories_by_b_id" => "c_categories#by_id"
  get "d_categories_by_c_id" => "d_categories#by_id"

  get "check_items_by_d_id" => "d_categories#check_items"

  # 更新 check items
  post 'd_categories/:id/update_check_items' => 'd_categories#update_check_items'

  resources :sys_provinces
  get 'prov_data' => 'sys_provinces#prov_data'
  get 'prov' => 'sys_provinces#prov'
  get 'sub_provs' => 'sys_provinces#sub_provs'
  post 'create_prov' => 'sys_provinces#create_prov'
  post 'update_prov' => 'sys_provinces#update_prov'

  match "tasks/deploy", via: [:get, :post]
  # 省局任务部署
  match "tasks/deploy_prov", via: [:get, :post]

  # 省局部署抽检任务
  post "tasks/create_delegate_plan"

  # 部署各省局抽检任务
  post "tasks/create_prov_plan"

  # 部署局本级任务
  post "tasks/create_direct_plan"

  # 部署局本级抽检任务
  post "tasks/create_top_plan"

  get "tasks/assign"
  get "assign_by_categories_id" => 'tasks#assign_validate'
  match 'tasks/check', via: [:get, :post]

  get "yycz/new"
  get "yycz/dj"
  get "yycz/gzap"
  get "yycz/renew"
  post "yycz/renew"
  get "yycz/cztb"
  get "yycz/czsh"
  get "yycz_from_bsb/:id" => "yycz#from_bsb"
  get "yycz/:id" => "yycz#show"
  get "yycz/:id/download_file" => "yycz#download_file"
  post "yycz_create" => "yycz#create"
  post "yycz/:id" => "yycz#update"
  post "yycz_assign_task" => "yycz#assign_task"
  post "yycz_revert" => "yycz#yycz_revert"
  post "wtyp_czb_revert" => "wtyp_czbs#revert"

  resources :spkj_bsbs

  resources :wtyp_czbs
  post 'wtyp_assign_task' => 'wtyp_czbs#assign_task'
  get 'wtyp_czbs_by_state/:state' => 'wtyp_czbs#index'
  post 'update_wtyp_czbs/:id' => 'wtyp_czbs#update'
  post 'wtyp_czbs/:part_id/duban' => 'wtyp_czbs#duban'
  get 'wtyp_xc_attachment/:id' => 'wtyp_czbs#xc_attachment'
  get 'wtyp_pc_attachment/:id' => 'wtyp_czbs#pc_attachment'
  get 'wtyp_xz_attachment/:id' => 'wtyp_czbs#xz_attachment'
  get 'wtyp_qd_attachment/:id' => 'wtyp_czbs#qd_attachment'

  resources :jg_bsbs do
    member do
      post 'rename'
      #get 'by_rwly'
    end

    collection do
      match 'merge_request', via: [:get, :post]
      get 'by_province'
      get 'by_jg_name'
    end
  end

  post "jg_bsbs_import_data_excel" => "jg_bsbs#import_data_excel"
  resources :jg_bsbs do
    member do
      get "attachment"
    end
  end


  resources :sp_company_infos
  get 'sp_company_infos_list' => 'sp_company_infos#list'
  get 'sp_company_info_by_yyzz' => 'sp_company_infos#by_yyzz'

  resources :sp_production_infos
  get 'sp_production_infos_list' => 'sp_production_infos#list'
  get 'sp_production_company_infos_list' => 'sp_production_infos#company_list'
  get 'sp_production_info_by_scxkz' => 'sp_production_infos#by_scxkz'

  resources :sp_standards
  resources :spdata
  resources :locations

  resources :flexcontents
  post "flexcontents_additem" => 'flexcontents#additem'
  get "flexcontents_additem" => 'flexcontents#additem'

  resources :hzp_bsbs
  post "hzp_bsbs_import_excel" => "hzp_bsbs#import_excel"
  post "hzp_bsbs_export_excel" => "hzp_bsbs#export_excel"
  post "hzp_bsbs_export_info_excel" => "hzp_bsbs#export_info_excel"
  post "hzp_bsbs_spsearch" => 'hzp_bsbs#spsearch'
  get "hzp_bsbs_spsearch" => 'hzp_bsbs#spsearch'
  get "hzp_bsb_submit" => 'hzp_bsbs#submit'
  post "hzp_bsbs_import_hzp_standards" => "hzp_bsbs#import_hzp_standards"
  post "hzp_bsbs_change_data_excel" => "hzp_bsbs#change_data_excel"

  resources :sp_bsbs do
    member do
      get "print"
      post "fail_pdf_report"
      post "remove_fail_report"
      get "fail_pdf_report"
      post "push_base_data"
      get 'xsbg'
      get "cyd"
      get "cyjygzs"
      get "preview_ca_pdf"
      get 'report'
    end
    collection do
     get 'no_available_pdf_found'
     get 'by_ca_info'
     get 'print_pdf'
     get 'super_jg'
     get 'sampling_process'
    end
  end
  resources :pad_sp_bsbs do
    member do
      get "accept_file"
      get "cyd"
      get "cyjygzs"
      get "picture/:sort_index" => "pad_sp_bsbs#picture"
    end
  end

  namespace "api" do
    namespace "v1" do
      post "sp_bsbs/submit/:id" => "sp_bsbs#submit"
      post "sp_bsbs/transfer" => "sp_bsbs#transfer"
      post "sp_bsbs/:id/do_step_:step" => "sp_bsbs#do_step"
      post "sp_bsbs/:id/upload_picture" => "sp_bsbs#upload_picture"
      get "sp_bsbs/:id/picture/:sort_index" => "sp_bsbs#picture"
      get "get_provinces" => "sp_bsbs#get_provinces"
      get "sp_bsbs/index"
      post "sp_bsbs/is_valid"
      get "sp_bsbs/check_sp_production_info"
      get "sp_bsbs/tasks"
      post "sp_bsbs/sync"
      post "users/auth"
      post "users/ca_auth"
			get 'users/ca_get_random'
      post "users/update_location"
			post 'sp_bsbs/:id/ca_sign' => 'sp_bsbs#ca_sign'

			get 'scqy' => 'sp_bsbs#scqy_infos'
			get 'bcydw' => 'sp_bsbs#bcydw_infos'

      get "client/version"
      get "client/download"
      post "hccz/list"
      get "hccz/list"
      get 'hccz/:cjbh/report' => 'hccz#report'
			post "sp_bsbs/sync_sp_bsb"
			post "spdata/sync_spdaum"
			post "spdata/transfer"
    end

    # 我查查
    namespace 'v3' do
      post 'openapi/sample_add_or_edit' => 'openapi#sample_add_or_edit'
      post 'openapi/sampledelete' => 'openapi#delete_sp_bsb'
      get  'user/login'
      #食安云
      post 'interface_user/new_user' => 'interface_user#new_user'
      post 'interface_user/update_user_uuid' => 'interface_user#update_user_uuid'
      post 'interface_jg/handing_jg_bsb' => 'interface_jg#handing_jg_bsb'
      post 'interface_jg/handing_jgbsb_super' => 'interface_jg#handing_jgbsb_super'
      post 'interface_region/new_region' => 'interface_region#new_region'
      post 'interface_stamps/jg_bsb_stamps_sync' => 'interface_stamps#jg_bsb_stamps_sync'
      post 'interface_baosong/baosongs_sync' => 'interface_baosong#baosong_sync'
    end
  end

  post "pad_sp_bsbs_spsearch" => "pad_sp_bsbs#spsearch"
  get "pad_sp_bsbs_spsearch" => "pad_sp_bsbs#spsearch"

  get "checkout_standard" => "sp_bsbs#checkout_standard"
  get "yycz_info_by_cydbh" => "yycz#yycz_info_by_cydbh"
  resources :static_queues
  post "sp_bsbs_import_excel" => "sp_bsbs#import_excel"
  post "sp_bsbs_import_data_excel" => "sp_bsbs#import_data_excel"
  post "sp_bsbs_import_temp_data_excel" => "sp_bsbs#import_temp_data_excel"
  post "sp_bsbs_import_zbydata_excel" => "sp_bsbs#import_zbydata_excel"
  post "sp_bsbs_import_zjydata_excel" => "sp_bsbs#import_zjydata_excel"
  post "sp_bsbs_export_excel" => "sp_bsbs#export_excel"
  post "sp_bsbs_export_data_excel" => "sp_bsbs#export_data_excel"
  post "sp_bsbs_export_excel_search" => "sp_bsbs#export_excel_search"
  post "sp_bsbs_export_excel_allinfo" => "sp_bsbs#export_excel_allinfo"
  match "sp_bsbs_export_excel_alldata" => "sp_bsbs#export_excel_alldata", via: [:get, :post]
  post "sp_bsbs_export_excel_all_wjc_data" => "sp_bsbs#export_excel_all_wjc_data"
  post "sp_bsbs_export_excel_all_jc_data" => "sp_bsbs#export_excel_all_jc_data"
  post "sp_bsbs_export_excel_all_hg_data" => "sp_bsbs#export_excel_all_hg_data"
  post "sp_bsbs_export_excel_all_bhg_data" => "sp_bsbs#export_excel_all_bhg_data"
  get "sp_bsbs_export_excel_all_bhg_data" => "sp_bsbs#export_excel_all_bhg_data"
  post "sp_bsbs_export_excel_all_bpd_data" => "sp_bsbs#export_excel_all_bpd_data"
  get "sp_bsbs_export_excel_all_bpd_data" => "sp_bsbs#export_excel_all_bpd_data"
  post "sp_bsbs_export_excel_qgztqkb" => "sp_bsbs#export_excel_qgztqkb"
  post "sp_bsbs_export_excel_ytqkb" => "sp_bsbs#export_excel_ytqkb"
  post "sp_bsbs_export_excel_wtypb" => "sp_bsbs#export_excel_wtypb"
  post "sp_bsbs_export_excel_whyzb" => "sp_bsbs#export_excel_whyzb"
  post "sp_bsbs_spsearch" => "sp_bsbs#spsearch"
  get "sp_bsbs_spsearch" => "sp_bsbs#spsearch"
  get "sp_bsbs_wtyptzs" => "sp_bsbs#wtyptzs"
  get "sp_bsbs_wtypchuli" => "sp_bsbs#wtypchuli"
  post "sp_bsbs_statistics" => "sp_bsbs#statistics"
  get "sp_bsbs_statistics" => "sp_bsbs#statistics"
  get "sp_bsbs_statisticsindex" => "sp_bsbs#statisticsindex"
  get "sp_bsbs_submit" => "sp_bsbs#submit"
  get "sp_bsbs_export_sta_info" => "sp_bsbs#export_sta_info"
  post "sp_bsbs_import_sta_info" => "sp_bsbs#import_sta_info"
  get "sp_bsbs_download_file" => "sp_bsbs#download_file"
  post "sp_bsbs_import_sp_standards" => "sp_bsbs#import_sp_standards"
  post "sp_bsbs_import_sp_standards_v2" => "sp_bsbs#import_sp_standards_v2"

  # resources :mytests
  # get "mytests_delete"=>"mytests#delete"

  resources :abcs

  resources :hzp_ypbs

  resources :bjp_bsbs
  post "bjp_bsbs_import_excel" => "bjp_bsbs#import_excel"
  post "bjp_bsbs_export_excel" => "bjp_bsbs#export_excel"
  post "bjp_bsbs_export_info_excel" => "bjp_bsbs#export_info_excel"
  get "bjp_bsbs_welcome" => 'bjp_bsbs#welcome'
  post "bjp_bsbs_bjpsearch" => 'bjp_bsbs#bjpsearch'
  get "bjp_bsbs_bjpsearch" => 'bjp_bsbs#bjpsearch'
  get "bjp_bsb_submit" => 'bjp_bsbs#submit'
  post "bjp_bsbs_import_bjp_standards" => "bjp_bsbs#import_bjp_standards"

  resources :hzp_bc_dws

  resources :orders

  resources :users do
    collection do
      get 'pending'
    end
  end
  resources :sp_bsb_info_publications do
    collection do
       get 'spsearch_publish'
       post 'upload_hege_excel'
       post 'upload_buhege_excel'
       get 'check_duplicate'
       get 'spsearch_publish_check' =>"sp_bsb_info_publications#spsearch_publish"
    end
  end
  post "spsearch_publish" => "sp_bsb_info_publications#spsearch_publish"
  get "spsearch_publish" => "sp_bsb_info_publications#spsearch_publish"
  get "upload_hege_excel" =>"sp_bsb_info_publications#upload_hege_excel"
  post "upload_hege_excel" =>"sp_bsb_info_publications#upload_hege_excel"
  post "upload_buhege_excel" =>"sp_bsb_info_publications#upload_buhege_excel"
  get "spsearch_publish_check" => "sp_bsb_info_publications#check_duplicate"
  post "spsearch_publish_check" => "sp_bsb_info_publications#check_duplicate"
  # 管理员创建用户
  post 'manager_create_users' => 'users#create'

  get "users_changeauthority" => "users#changeauthority"
  post "users_import_data_excel" => "users#import_data_excel"
  post "users_export_user_info" => "users#export_user_info"
  get "users_by_jcjg" => "users#users_by_jcjg"
  get "users/timeout"
  get 'complete_user_info' => 'users#complete_user_info'
  get 'in-review' => 'users#in_review'
  match "bind_ca_key" => "users#bind_ca_key", via: [:get, :post]

  resources :products

  get "mygetdata" => 'hzp_ypbs#mygetdata'
  get "main/index"
  post "main/index"
  get "main/welcome"
  get "main/welcome2"
  get "files/:name" => "main#file"
  get "main/re"
  get "main/authority"

  post "admin/login"
  get "admin/login"


  post '/ca_login' => 'admin#ca_login'
  post '/ca_logout' => 'admin#logout'

  get 'switch' => 'switch#index'
  get 'switch/update_radio' => 'switch#update_radio'

  post "admin/logout"
  get "admin/logout"

  get "admin/index"

  get "admin/adduser"

  get "data/index"
  post "data/seach"
  get "data/seach"
  delete "del_data/:id" =>"data#destroy"
  root :to => 'welcome_notices#index'

  #数据统计
  get 'statistics' => 'statistics#statistics'
  get 'task_statistics' => 'statistics#task_statistics'
  get 'food_statistics' => 'statistics#food_statistics'
  get 'nonconformity_statistics' => 'statistics#nonconformity_statistics'
  get 'unit_statistics' => 'statistics#unit_statistics'
  get 'overtime_statistics' => 'statistics#overtime_statistics'
  get 'disposal_statistics' => 'statistics#disposal_statistics'
  get 'enterprise_statistics' => 'statistics#enterprise_statistics'
  get 'early_warning' => 'statistics#early_warning'
  get 'composite_statistics' => 'statistics#composite_statistics'


end
