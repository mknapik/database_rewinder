module DatabaseRewinder
  module InsertRecorder
    def execute_recorder(sql, *args)
      DatabaseRewinder.record_inserted_table self, sql
      execute_original(sql, *args)
    end

    def exec_query_recorder(sql, *args)
      DatabaseRewinder.record_inserted_table self, sql
      exec_query_original(sql, *args)
    end

    def self.included(base)
      base.class_eval do
        alias_method :execute_original, :execute
        alias_method :execute, :execute_recorder

        alias_method :exec_query_original, :exec_query
        alias_method :exec_query, :exec_query_recorder
      end
    end
  end
end

begin
  require 'active_record/connection_adapters/sqlite3_adapter'
  ::ActiveRecord::ConnectionAdapters::SQLite3Adapter.send :include, DatabaseRewinder::InsertRecorder
rescue LoadError
end
begin
  require 'active_record/connection_adapters/postgresql_adapter'
  ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send :include, DatabaseRewinder::InsertRecorder
rescue LoadError
end
begin
  require 'active_record/connection_adapters/abstract_mysql_adapter'
  ::ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter.send :include, DatabaseRewinder::InsertRecorder
rescue LoadError
end
