class Rebase

  def initialize(hashOne, hashTwo, dateOne, dateTwo)
    @hashOne = hashOne
    @hashTwo = hashTwo
    @dateOne = dateOne
    @dateTwo = dateTwo
  end

  def getHashOne()
    @hashOne
  end

  def getHashTwo()
    @hashTwo
  end

  def getDateOne()
    @dateOne
  end

  def getDateTwo()
    @dateTwo
  end

end