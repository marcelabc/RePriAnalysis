require 'date'
require 'time'

class ActionLog

  def initialize(line)
    @originalLine = line
    @gitHash = findHashFromLine()
    @date = findDateFromLine()
    @command = findCommandFromLine()
    @message = findMessageFromLine()
    @associatedLogs = []
    @teste = ""
  end

  def getGitHash()
    @gitHash
  end

  def getOriginalLine()
    @originalLine
  end

  def getDate()
    @date
  end

  def getCommand()
    @command
  end

  def getMessage()
    @message
  end

  def getAssociatedLogs()
    @associatedLogs
  end

  def setAssociatedLogs(logs)
    @associatedLogs = logs
  end

  def findHashFromLine()
    return @originalLine.match(/^[0-9a-zA-Z]{7,7} /).to_s.gsub(" ","")
  end

  def findDateFromLine()
    return DateTime.parse(getOriginalLine().match(/HEAD@{[a-zA-Z0-9\- \:]*}/).to_s.gsub("HEAD@{","").gsub("}",""))
  end

  def findCommandFromLine()
    if (@originalLine.include? "clone")
      return @originalLine.match(/HEAD@{[a-zA-Z0-9\- \:]*}\: [\s\S]*\:/).to_s.match(/\: [\s\S]*\: /).to_s.gsub(" :","").gsub(": ","")
    else
      return @originalLine.match(/HEAD@{[a-zA-Z0-9\- \:]*}\: [\s\S]*\:/).to_s.match(/\: [\s\S]*\:/).to_s.gsub(" :","").gsub(":","")
    end
  end

  def findMessageFromLine()
    return @originalLine.split(@command).last.to_s.gsub(": ","")
  end

end