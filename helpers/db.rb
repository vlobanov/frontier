DB = Sequel.connect('mysql2://root@localhost/amazing_cache')

module DBHelper
  module_function

  def count
    sdata.count
  end

  def sdata
    DB[:sdata]
  end

  def insert(params)
    sdata.insert(params)
  end

  def update(id, params)
    sdata.where(id: id).update(params)
  end

  def create_table!
    sql = <<-SQL
      CREATE TABLE `sdata` (
        `id` bigint(20) unsigned NOT NULL DEFAULT 0,
        `name` varchar(64) DEFAULT NULL,
        `kind` bigint(20) unsigned DEFAULT NULL,
        `value` decimal(10,2) DEFAULT NULL,
        PRIMARY KEY (`id`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
    SQL
    DB.run('DROP TABLE IF EXISTS sdata')
    DB.run(sql)
  end
end
