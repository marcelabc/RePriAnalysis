require 'date'
require 'time'

class MavenLog

  def initialize(pathLog)
    @pathLog = pathLog
    @date = convertDateFromFile()
    @gitHash = convertGitHashFromFile()
  end

  def getPathLog()
    @pathLog
  end

  def getDate()
    @date
  end

  def getGitHash()
    @gitHash
  end

  def convertDateFromFile()
    return DateTime.parse(@pathLog.to_s.gsub("|", " ").gsub(".log",""))
  end

  def convertGitHashFromFile()
    return @pathLog[/\"[a-zA-Z0-9]*\"/].to_s.gsub("\"","")
  end
end