require "albacore/albacoretask"
require "albacore/config/nugetpushconfig"
require "albacore/support/supportlinux"

class NuGetPush
  TaskName = :nugetpush

  include Albacore::Task
  include Albacore::RunCommand
  include Configuration::NuGetPush
  include SupportsLinuxEnvironment
  
  attr_accessor :package,
                :apikey,
                :source

  def initialize()
    super()
    update_attributes(nugetpush.to_hash)
    @command = "nuget"
  end

  def execute
    unless @package
      fail_with_message("nugetinstall requires #package")
      return
    end

    result = run_command("nugetpush", build_parameters)
    fail_with_message("NuGet Push failed, see the build log for more details.") unless result
  end
  
  def build_parameters
    p = []
    p << "push"
    p << "\"#{@package}\""
    p << "#{@apikey}" if @apikey
    p << "-Source #{source}" if @source
    p
  end
end