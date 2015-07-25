namespace :load do
  task :defaults do
    set :twenty_nine_hours_log, -> { shared_path.join('29hours', 'log', '29hours.log') }
    set :twenty_nine_hours_pid, -> { shared_path.join('29hours', 'tmp', 'pids', '29hours.pid') }
  end
end

namespace :twenty_nine_hours do
  desc 'Start 29hours'
  task :start do
    on roles(:app) do
      within current_path.join('29hours') do
        if test("[ -e #{fetch(:twenty_nine_hours_pid)} ] && kill -0 #{twenty_nine_hours_pid}")
          info '29hours is running...'
        else
          execute :bundle, 'exec ruby 29hours.rb --production >>', fetch(:twenty_nine_hours_log), '2>&1 &; echo $! > ', fetch(:twenty_nine_hours_pid)
        end
      end
    end
  end

  desc 'Stop 29hours'
  task :stop do
    on roles(:app) do
      within current_path.join('29hours') do
        if test("[ -e #{fetch(:twenty_nine_hours_pid)} ]")
          if test("kill -0 #{twenty_nine_hours_pid}")
            info 'stopping 29hours...'
            execute :kill, twenty_nine_hours_pid
          else
            info 'cleaning up dead 29hours pid...'
          end
          execute :rm, fetch(:twenty_nine_hours_pid)
        else
          info '29hours is not running...'
        end
      end
    end
  end

  def twenty_nine_hours_pid
    "`cat #{fetch(:twenty_nine_hours_pid)}`"
  end
end
