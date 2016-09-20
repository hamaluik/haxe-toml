package;

import toml.TOMLParser;

class Main {
    public static function main() {
        var src:String = sys.io.File.getContent("simple.toml");

        var lexer = new toml.TOMLParser.TOMLLexer(byte.ByteData.ofString(src), "simple.toml");
        var tokens = [];
        try while(true) {
            tokens.push(lexer.token(toml.TOMLParser.TOMLLexer.tok));
        }
        catch(_e:Dynamic)
            trace(_e);
        trace(tokens);
        trace("done lexing");

        var parser = new toml.TOMLParser.TOMLParser(byte.ByteData.ofString(src), "simple.toml");
        parser.parse();
    }
}
