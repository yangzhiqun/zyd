#!/usr/bin/env ruby

require 'mysql2'
require 'pp'

DB_CONFIG = {:host => "localhost", :username => "root", :password => "123456", :database => "depot_demo_development"}

CLIENT = Mysql2::Client.new(DB_CONFIG)


# 取出用户原tname与用户id的对应关系,放到 @user_mapper
@user_mapper = {}
CLIENT.query('select tname, id, uid from users').each do |user|
  @user_mapper[user['tname']] = [user['id'], user['uid']]
end

# 将系统中原有用户的状态更新为9, 即：正常在用InUse
CLIENT.query('update users set state = 9')

# 取出spbsbs的总数
sp_bsbs_count = CLIENT.query('select count(1) as count from sp_bsbs where user_id is null').first['count']

# 每个线程的处理数量
THREAD_SIZE = 50000

threads = []
# 开启总共的县城数量
(sp_bsbs_count.to_f / THREAD_SIZE).ceil.times do |i|
  threads << Thread.new do
    client = Mysql2::Client.new(DB_CONFIG)
    puts "Thread #{i} started.\n"

    client.query("select sp_s_16, sp_s_37, tname, id from sp_bsbs where user_id is null limit #{THREAD_SIZE} offset #{(i + 1) * THREAD_SIZE}").each_with_index do |row, index|
      if @user_mapper.has_key?(row['tname'])
        user_id = @user_mapper[row['tname']]
        sql = "update sp_bsbs set user_id = #{user_id[0]}, sp_s_37_user_id = #{user_id[0]} where id=#{row['id']}"

        client.query(sql)

        puts "T:#{i}, Updated: GC: #{row['sp_s_16']}, #{index}/#{THREAD_SIZE}\n#{sql}\n"
      else
        puts "User Not Found: #{row['tname']}\n"
      end
    end
    puts "Thread #{i} ended."
  end
end


# 异议处理
threads << Thread.new do
  puts 'SpYydjb Thread Started.'
  client = Mysql2::Client.new(DB_CONFIG)
  client.query('SELECT id, djr, blr, tbr, shr FROM sp_yydjbs where djr_user_id IS NULL').each do |row|
    fields = {}
    fields[:djr_user_id] = @user_mapper[row['djr']][0] if @user_mapper.has_key?(row['djr'])
    fields[:blr_user_id] = @user_mapper[row['blr']][0] if @user_mapper.has_key?(row['blr'])
    fields[:tbr_user_id] = @user_mapper[row['tbr']][0] if @user_mapper.has_key?(row['tbr'])
    fields[:shr_user_id] = @user_mapper[row['shr']][0] if @user_mapper.has_key?(row['shr'])

    unless fields.empty?
      sql = "UPDATE sp_yydjbs SET #{fields.map { |f, v| "#{f} = #{v}" }.join(',')} where id=#{row['id']}"

      client.query(sql)

      puts "YYDJB: #{sql}\n"
    end
  end
end

# 核查处置
threads << Thread.new do
  puts 'WtypCzb Thread Started.'
  client = Mysql2::Client.new(DB_CONFIG)
  client.query('SELECT id, blr, tbr, shr FROM wtyp_czb_parts where blr_user_id IS NULL AND tbr_user_id IS NULL AND shr_user_id IS NULL').each do |row|
    fields = {}
    fields[:blr_user_id] = @user_mapper[row['blr']][0] if @user_mapper.has_key?(row['blr'])
    fields[:tbr_user_id] = @user_mapper[row['tbr']][0] if @user_mapper.has_key?(row['tbr'])
    fields[:shr_user_id] = @user_mapper[row['shr']][0] if @user_mapper.has_key?(row['shr'])

    unless fields.empty?
      sql = "UPDATE wtyp_czb_parts SET #{fields.map { |f, v| "#{f} = #{v}" }.join(',')} where id=#{row['id']}"
      client.query(sql)
      puts "WTYP_PARTS: #{sql}\n"
    end
  end
end

threads.each do |t|
  t.join
end
