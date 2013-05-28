module ChampionshipsHelper

  # generate a simple nested list for show or edit
  def markup_for_championship(championship, *args)
    options = args.extract_options!
    traverse_tree(championship.board, options[:for_edit] || (action_name == 'edit'))
  end

private

  def markup_for(item, for_edit)
    template = for_edit ? 'edit_embedded' : 'show_embedded'
    link_to '#', class: 'tree' do
      render partial: [item.class.name.downcase.pluralize, template].join('/'), object: item
    end
  end

  def traverse_tree(node, for_edit)
    return if node.blank?
    children = node.children
    subtree_html = ActiveSupport::SafeBuffer.new
    if !children.empty?
      subtree_html << content_tag(:li, traverse_tree(children.first, for_edit), class: html_class_for_branch(node, children.first))
      subtree_html << content_tag(:li, traverse_tree(children.second, for_edit), class: html_class_for_branch(node, children.second))
      subtree_html = content_tag(:ul, subtree_html)
    end
    subtree_html << markup_for(node.content, for_edit)
  end

  def is_winner?(node, branch)
    node.content.explicit_or_implicit_winner == branch.content.explicit_or_implicit_winner
  end

  def html_class_for_branch(node, branch)
    is_winner?(node, branch) ? "winner_branch" : nil
  end

end
