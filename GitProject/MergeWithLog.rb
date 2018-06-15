class MergeWithLog

  def initialize(commitOne, commitTwo)
    @commitOne = commitOne
    @commitTwo = commitTwo
    @buildLogs = Array.new
  end

  def getCommitOne()
    @commitOne
  end

  def getCommitTwo()
    @commitTwo
  end

  def getBuildLogs()
    @buildLogs
  end

  def addBuildLog(mavenLog)
    @buildLogs.push(mavenLog)
  end

end