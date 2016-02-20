#!/usr/bin/env ruby

require 'mysql2'
require 'pp'

CLIENT = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "123456", :database => "depot_demo_development")

@user_mapper = {}
CLIENT.query('select tname, id, uid from users').each do |user|
  @user_mapper[user['tname']] = [user['id'], user['uid']]
end

sp_bsbs_count = CLIENT.query('select count(1) as count from sp_bsbs').first['count']
THREAD_SIZE = 100000

threads = []
(sp_bsbs_count.to_f / THREAD_SIZE).ceil.times do |i|
  threads << Thread.new do
    client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "123456", :database => "depot_demo_development")
    puts "Thread #{i} started.\n"

    client.query("select sp_s_16, sp_s_37, tname, id from sp_bsbs where user_id is null or uid is null limit #{THREAD_SIZE} offset #{i + THREAD_SIZE}").each_with_index do |row, index|
      if @user_mapper.has_key?(row['tname'])
        user_id = @user_mapper[row['tname']]
        sql = "update sp_bsbs set user_id = #{user_id[0]}, uid = '#{user_id[1]}', sp_s_37_user_id = #{user_id[0]} where id=#{row['id']}"

        puts "T:#{i}, Updated: GC: #{row['sp_s_16']}, #{index}/#{THREAD_SIZE}\n#{sql}\n"
      else
        puts "User Not Found: #{row['tname']}\n"
      end
    end
    puts "Thread #{i} ended."
  end
end


threads << Thread.new do
  puts 'SpYydjb Thread Started.'
  client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "123456", :database => "depot_demo_development")
  client.query('SELECT id, djr, blr, tbr, shr FROM sp_yydjbs').each do |row|
    fields = {}
    fields[:djr_user_id] = @user_mapper[row['djr']][0] if @user_mapper.has_key?(row['djr'])
    fields[:blr_user_id] = @user_mapper[row['blr']][0] if @user_mapper.has_key?(row['blr'])
    fields[:tbr_user_id] = @user_mapper[row['tbr']][0] if @user_mapper.has_key?(row['tbr'])
    fields[:shr_user_id] = @user_mapper[row['shr']][0] if @user_mapper.has_key?(row['shr'])

    unless fields.empty?
      sql = "UPDATE sp_yydjbs SET #{fields.map { |f, v| "#{f} = #{v}" }.join(',')} where id=#{row['id']}"
      puts "YYDJB: #{sql}\n"
    end
  end
end

threads << Thread.new do
  puts 'WtypCzb Thread Started.'
  client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "123456", :database => "depot_demo_development")
  client.query('SELECT id, blr, tbr, shr FROM wtyp_czb_parts').each do |row|
    fields = {}
    fields[:blr_user_id] = @user_mapper[row['blr']][0] if @user_mapper.has_key?(row['blr'])
    fields[:tbr_user_id] = @user_mapper[row['tbr']][0] if @user_mapper.has_key?(row['tbr'])
    fields[:shr_user_id] = @user_mapper[row['shr']][0] if @user_mapper.has_key?(row['shr'])

    unless fields.empty?
      sql = "UPDATE wtyp_czb_parts SET #{fields.map { |f, v| "#{f} = #{v}" }.join(',')} where id=#{row['id']}"
      puts "WTYP_PARTS: #{sql}\n"
    end
  end
end

threads.each do |t|
  t.join
end
