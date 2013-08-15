
class KnightPathFinder
  def initialize (starting_pos)
    @starting_pos = starting_pos
    build_move_tree # << @starting_pos
  end


  def find_path(target)
    final_node = @move_tree[target].multi_bfs(@starting_pos){|node| node if node.value == target}
    final_path = final_node.path
    final_path.each{|i| p i}
  end

  def build_move_tree
    @move_tree = {}
    start = @starting_pos
    positions = [start]

    while positions.length > 0
      current_position = positions.shift
      if !@move_tree.keys.include?(current_position)
        node = TreeNode.new(current_position)
        @move_tree[current_position] = node
      end
      child_positions = KnightPathFinder.new_move_positions(current_position)
      child_positions.each do |position|
        if !@move_tree.keys.include?(position)
          new_node = TreeNode.new(position)
          new_node.parent = @move_tree[current_position]
          @move_tree[position] = new_node
          positions << position
        end
      end
    end
  end

  def self.new_move_positions(position)
    x, y = position[0] ,position[1]

    valid_moves = []
    position_checks = [[-2,1],
                       [-1,2],
                       [1,2],
                       [2,1],
                       [2,-1],
                       [1,-2],
                       [-1,-2],
                       [-2,-1]]

    position_checks.each_with_index do |pos, index|
      if (pos[0] + x >= 0 &&
          pos[0] + x <= 7 &&
          pos[1] + y >= 0 &&
          pos[1] + y <= 7)
          valid_moves << [pos[0] + x, pos[1] + y]
      end
    end
    valid_moves
  end
end


class TreeNode
  attr_accessor :parent, :value
  attr_reader :children

  def initialize(value = nil)
    @value = value
    @parent = nil
    @children = []
  end

  def add_children(*child_nodes)
    child_nodes.each do |child_node|
      @children << child_node
    end
    @children
  end

  def dfs(target,visited = [])
    if self.value == target
      return self
    elsif self.left.nil? && !visited.include?(self) #there is no left and we haven't already visited s node
      if self.parent.right == target
        return self.parent.right
      elsif self.parent.right == self
        return nil
      else
        self.parent.right.dfs(target)
      end
    elsif !self.left.nil? #there is a left
      visited << self
      self.left.dfs(target,visited)
    end
  end

  def multi_dfs(target, &block)
    if !block_given?
      block = Proc.new {|node| node.value == target}
    end

    return self if block.call(self)

    if self.children.length > 0
        self.children.each do |child_node|
          some_node = child_node.multi_dfs(target,&block)
          return some_node if some_node
      end
    end
    nil
  end

  def path
    path = []
    node = self
    while true
      path << node.value
      break if node.parent == nil
      node = node.parent
    end

    path
  end

  def multi_bfs(target, &block)
    if !block_given?
      block = Proc.new {|node| node.value == target}
    end

    nodes = [self]
    until nodes.empty?
    children_nodes = []

    nodes.each do |node|
      return node if block.call(node)

      self.children.each do |child|
        children_nodes << child
      end
      children_nodes.compact!
      nodes += children_nodes
     end
   end
   return nil
  end

  def bfs(target)
    nodes = [self]

    until nodes.empty?
      children_nodes = []

      nodes.each do |node|
        return node if node.value == target
        children_nodes << node.left
        children_nodes << node.right
        children_nodes.compact!

        children_nodes.each do |child_node|
          if child_node.value == target
            return child_node
          else
            nodes += children_nodes
          end
        end

      end
    end
    return nil
  end
end







kpf = KnightPathFinder.new([0,0])
kpf.find_path([3,3])

#
# def multi_bfs(target, &block)
#   if !block_given?
#     block = Proc.new {|node| node.value == target}
#   end
#
#   nodes = [self]
#   until nodes.empty?
#   children_nodes = []
#
#   nodes.each do |node|
#     return node if block.call(node)
#
#     self.child.each do |child|
#       children_nodes << child
#     end
#
#     children_nodes.compact!
#     nodes += children_nodes
#    end
#  end
#  return nil
# end










# def build_move_tree
#   @move_tree = [@starting_position]
#   @move_map = {}
#
#   positions = [@starting_position]
#   positions.each do |position|
#     @move_map[position] = self.class.new_move_positions(position)
#
#     @move_map.keys.each do |valid_move|
#       @move_tree << valid_move if !@move_tree.include?(valid_move)
#       positions = @move_tree - position
#     end
#
#
#   return @move_tree
# end