
class EdgeColoringGraph
  def initialize map
    @edges = map
  end

  def edge(x, y)
    @edges[x][y]
  end
end
