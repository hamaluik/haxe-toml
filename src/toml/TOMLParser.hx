package toml;

import byte.ByteData;
import hxparse.Lexer;
import hxparse.LexerTokenSource;
import hxparse.Parser;
import hxparse.ParserBuilder;
import hxparse.RuleBuilder;

private enum Token {
    THash;
    TChar(c:String);
    TEquals;
    TNumber(f:Float);
    TWhitespace;
    TNewline;
}

class TOMLLexer extends Lexer implements RuleBuilder {
    static public var tok = @:rule [
        "#" => {
            lexer.token(comment);
            THash;
        },
        "-?(([1-9][0-9]*)|0)(.[0-9]+)?([eE][\\+\\-]?[0-9]?)?" => TNumber(Std.parseFloat(lexer.current)),
        "=" => TEquals,
        "[a-zA-Z]" => TChar(lexer.current),
        "[\t ]" => TWhitespace,
        "\r?\n" => TNewline
    ];

    static var comment = @:rule [
        "[^\n]" => {
            lexer.token(comment);
        },

        "\n" => {
            lexer.curPos().pmax;
        }
    ];
}

class TOMLParser extends Parser<LexerTokenSource<Token>, Token> implements ParserBuilder {
    public function new(input:ByteData, ?sourceName:String) {
        var lexer:TOMLLexer = new TOMLLexer(input, sourceName);
        var ts:LexerTokenSource<Token> = new LexerTokenSource(lexer, TOMLLexer.tok);
        super(ts);
    }

    public function parse() {
        var v:Dynamic = switch stream {
            case [THash]: "#";
            case [TChar(c)]: '"${c}"';
            case [TEquals]: "=";
            case [TNumber(f)]: '${f}';
            case [TWhitespace]: "_";
            case [TNewline]: "NL";
        };

        trace(v);
        try {
            parse();
        }
        catch(_e:Dynamic) {
            trace('done!');
        }
    }
}