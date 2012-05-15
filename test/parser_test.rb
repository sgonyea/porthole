$LOAD_PATH.unshift File.dirname(__FILE__)
require 'helper'

class ParserTest < Test::Unit::TestCase
  def test_parser
    lexer = Porthole::Parser.new
    tokens = lexer.compile(<<-EOF)
<h1>%%header%%</h1>
%%#items%%
%%#first%%
  <li><strong>%%name%%</strong></li>
%%/first%%
%%#link%%
  <li><a href="%%url%%">%%name%%</a></li>
%%/link%%
%%/items%%

%%#empty%%
<p>The list is empty.</p>
%%/empty%%
EOF

    expected = [:multi,
      [:static, "<h1>"],
      [:porthole, :etag, [:porthole, :fetch, ["header"]]],
      [:static, "</h1>\n"],
      [:porthole,
        :section,
        [:porthole, :fetch, ["items"]],
        [:multi,
          [:porthole,
            :section,
            [:porthole, :fetch, ["first"]],
            [:multi,
              [:static, "  <li><strong>"],
              [:porthole, :etag, [:porthole, :fetch, ["name"]]],
              [:static, "</strong></li>\n"]],
            %Q'  <li><strong>%%name%%</strong></li>\n',
            %w[%% %%]],
          [:porthole,
            :section,
            [:porthole, :fetch, ["link"]],
            [:multi,
              [:static, "  <li><a href=\""],
              [:porthole, :etag, [:porthole, :fetch, ["url"]]],
              [:static, "\">"],
              [:porthole, :etag, [:porthole, :fetch, ["name"]]],
              [:static, "</a></li>\n"]],
            %Q'  <li><a href="%%url%%">%%name%%</a></li>\n',
            %w[%% %%]]],
        %Q'%%#first%%\n  <li><strong>%%name%%</strong></li>\n%%/first%%\n%%#link%%\n  <li><a href="%%url%%">%%name%%</a></li>\n%%/link%%\n',
        %w[%% %%]],
      [:static, "\n"],
      [:porthole,
        :section,
        [:porthole, :fetch, ["empty"]],
        [:multi, [:static, "<p>The list is empty.</p>\n"]],
        %Q'<p>The list is empty.</p>\n',
        %w[%% %%]]]

    assert_equal expected, tokens
  end

  def test_raw_content_and_whitespace
    lexer = Porthole::Parser.new
    tokens = lexer.compile("%%#list%%\t%%/list%%")

    expected = [:multi,
      [:porthole,
        :section,
        [:porthole, :fetch, ["list"]],
        [:multi, [:static, "\t"]],
        "\t",
        %w[%% %%]]]

    assert_equal expected, tokens
  end
end
