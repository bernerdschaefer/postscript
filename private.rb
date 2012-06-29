require "stringio"
$:.unshift "./lib"

# require "postscript"
script = DATA.read.force_encoding('binary')

# p script

script = <<-EOS
%!FontType.....
%%FontType.....
9 string currentfile exch readstring abc 123ab pop

10 dict begin
EOS

module PostScript
  class Source < StringIO
  end

  class Tokenizer
    def initialize(source)
      @source = source
    end

    def next
      token = ""

      loop do
        return nil unless char = @source.getc

        if char == '%'
          loop do
            return nil unless char = @source.getc
            break if char =~ /\r|\n/
          end
        end
        next if char =~ /\s/ && token.empty?
        break if char =~ /\s/

        token << char
      end

      parse_token(token)
    end

    def parse_token(token)
      case token
        when /^\//
          token[1..-1]
        when /^ -? [0-9]+ $/x
          Integer(token)
        when "true"
          true
        when "false"
          false
        else
          token.to_sym
      end
    end
  end

  class Interpreter
    def initialize(source)
      @source = source
      @tokenizer = Tokenizer.new(source)
    end

    def run
      while token = @tokenizer.next
        if token.is_a? Symbol
          send token
        else
          stack << token
        end
      end
    end

    def stack
      @stack ||= []
    end

    private

    def string
      size = stack.pop

      stack.push String.new(size)
    end

    def currentfile
      stack.push @source
    end

    def pop
      stack.pop
    end

    def exch
      stack.push *(stack.pop(2).reverse)
    end

    def readstring
      string = stack.pop
      file = stack.pop

      stack.push file.read(string.size, string)
      stack.push true
    end

    def dict
      stack.push Dictionary.new(stack.pop)
    end

    def dup
      stack.push stack.last.dup
    rescue TypeError
      stack.push stack.last
    end

    def begin

    end

    def def

    end

    def end
    end
  end

  class String < ::String
    attr_reader :size

    def initialize(size)
      @size = size
    end
  end

  class Dictionary < Hash
    def initialize(size)
      @size = size
    end
  end
end

source = PostScript::Source.new(script)
interpreter = PostScript::Interpreter.new(source)
interpreter.run
p interpreter.stack

# p PostScript::Parser.parse(script)
__END__
dup /Private 9 dict dup begin/RD {string currentfile exch readstring pop} executeonly def/ND {noaccess def} executeonly def/NP {noaccess put} executeonly def/BlueValues [] def/MinFeature {16 16} def/password 5839 def/lenIV 4 def/BlueFuzz 0 def2 index /CharStrings 56 dict dup begin/.notdef 9 RD �Gy�2?G ND
/space 9 RD �Gy�2?G ND
/A 58 RD �Gp����alC(��8�3�T�ɬ �����J2��l��s{N��}��w7 ND
/l 23 RD �G-Ŭ^��A�Ui��O�9��� ND
/s 187 RD �GX&���<����������v�PG}`3�(��M�.ep�=w� Ε#2�
|�т���^�D����]Ǝs�*��&��Q[ ���@w G�t��@�?F�)]��97��I�5	��H*`��8n��L 1#��z��p��D�|+3�t���v+�!*�M:���E�BR��ޚ�*���V��l ND
/I 24 RD �GQ��#s�N-��߁m� ~6! ND
/n 94 RD �G) *�x8�p�H�]yo����2�KL~ч~>�`���.�5Wk����ǡ�i�����wLȍ��e��|��f3/��'v����zsd�
�� ND
/g 232 RD �GEt�<C]�I7)�Б#�:nĹ��/R�
��33`�
�k�ſ{�J�f
D�*Um�Ϣ��{�&���
�#۽�ۀfח8�%e&� ��5�����4��k"�!�y�Mlv�`��VM�s���q�q �O<K�o�/r�Z����>��A��CU`��i\�*@ڹ\|2�c"���-(~�$�B?��Bp��z��0l��C�5��6Q	^��u,d�����7��}��'� ND
/e 142 RD �GDE�u��Ho�:AX��"Bb��s��_)�E��Ӻ0�PN/��~_5)l��GQ�oxI�v3Ʒ�*ߤ���4�G��R���B�C.d��"ǚ���q��/�u�+��D���o��c4����)yF���S9Jy��'��dAY ND
/i 89 RD �G"��V��}v�-�,{n>wH=�d���@�JF�q	�&�#ka�}҈�Y$��gޖ�9}di�J���*v4&�;Q�wʏ�"����r ND
/u 89 RD �G) 0�*�A��D&�hd�#רwx���F��������x�J�b��"��+Д|D+r�ZG�F�aa;�q�B���<�z2n�I� ND
/r 87 RD �G)d���l[�C�����B鬂-�#G�ڗ�C�YML��zk�'�3�A����d�*�G�E| ���[��zw��-��-<W�� ND
/c 130 RD �GJl�^�g��?��`�LB��GsH��1�+��0o�M^8�X��77��*x��X'�O5R~ҡ��a��w$�w��IR��FsT_���B[��y2m��obҍt��4>b��Ѥ�ى��D��ͷ;N} ND
/h 95 RD �G) *�x8��d\s�a]��E�!!�nr>{�;�oM� �(*14�G١k���g�۴_j�u�hʀ"J3��o�!�$�D��n� ND
/a 148 RD �GF����D3*h�\0�cld���v�|��7�Y<��rD�t�{���鈝�Db�h���
U�/�F�;��=�ؽ9[7��X�z�]�@�H�����>����C�\�M�!��;�F)P�)��PMఒ���T%R ��&�̖��Q� ND
/f 106 RD �Gj�z������n�3v���������K}y`��zYһi~�r��F�1��C��zo��ԉ�a҃2���h>)�Q��J�v�w�;����HP�Ѭh`����� ND
/t 50 RD �Gj�aPJ��pĠ��j4���ŷr6�4��>���ӫ���Z�oj�)� ND
/udieresis 212 RD �G) 0�*�A��D&�hd�#רwx���F��������x�J�b��"��+Д|D+r�ZG�F�aa;�q�B���<�z2n�I /y���E�q�������M9,��g��}��K�৾���%,������˗���wڅ�7��(�N��CB ��X[��$�]�^�l�`H�P����.7�h���ɗѪ�I�Q��Q� ND
/T 40 RD �GlV�@	|��E�m��5ٶ%Mq{�L���
�XFv� ND
/w 55 RD �Ge�Ԇ#)复�6�G8��Y}`�#סS�g.���R��� ��9�͚��ZX ND
/k 54 RD �G) �'�Ԃ�}a��@{��|�M-Ҹ�<���SG�]�����[ȠP{���� ND
/p 150 RD �G) "J����m��.�]߸�Ar%���e��q+T+֩CS@�.Ò��j��(.,[��l=��:�]}�k��[�^ .�¸� �md�{�>�\QQ��賊��b,���L������N� hV��G�� ň����]�  ND
/m 160 RD �G)ȱ � ׄ.�+ā�h��X�@1�* ��B�ʞW~�S[<���dGc�Ŵ�X�&�5��a�P*��ϝ`����$�F��~M*:E�dm�}[v�n
:��9to�ke�"��L�G;��"Z�$�-�^#c �*������,U��(As1�ia ND
/S 188 RD �G_{ՑR��aZ�6K@�0Fg�xQ�}�og^3�JgiR�es(�}0Xn�hhA��#�q��J�X��Z6%��0"=<��#��`��Aߦ8$KJ�K3,&�p�S.%�b�78��i�U�����Xrg8�h%[���9���Zt���:%�W,��UX�GsbpO�Z�[��E[�I��hr�X(T ND
/z 41 RD �Gds�˿TR�	x�)cm�u�����&����M�;|�� ND
/d 149 RD �GDE��������Y�cj�M<b��ҋN���"b�:����p�Ge�~����:�^:�L��H�\�1��s��!��?�m���١(W�K�PqDH���R��.��o���n+�}J����V���裋gT���' ��8�ƹ ND
/v 35 RD �Gh=��-�ܧ��/\�1��uG��u��(�۩� ND
/B 222 RD �G^T��x
���v�<�����N�rL�|��|�b�-�)0i���P�D��Kz���Cw�+��{c�ԇ�����zR�iζ����u�7/��X-5�Z}�1���a����/�!�LZ�8ڿ�30�!�1�e<g`���(�'�E�HK�����'B���H�����/1���g�L��j*ȫq�o\��{r&H�����6j{���� ND
/comma 25 RD �G4 �X�#'��nU16�O�w& ND
/adieresis 270 RD �GF����D3*h�\0�cld���v�|��7�Y<��rD�t�{���鈝�Db�h���
U�/�F�;��=�ؽ9[7��X�z�]�@�H�����>����C�\�M�!��;�F)P�)��PMఒ���T%R ��&�̖��Q�6�����5l�*D�ٍ�4�~�gI/���s;O�C"VQ�K���==NUL�n����ID�΄&;q�]���O�5[��X�eq��*�3P����D�pv,�IrI�?�{���7UϺ� ND
/period 69 RD �GYQ������i��U2B5�N�=bL�ƵO�N6L�y��:&�V%f�в���;{�ESD[�]� ND
/Z 41 RD �Ge�R_����I��.7��K�o���������.e ND
/V 35 RD �Gp��.��YK����!s9z�3Zs��{\c�K� ND
/E 54 RD �G^|'��>OB�"���a�"L|)B�`�s�ی���;��m5�6���[!� ND
/j 89 RD �G"��V��}v�-�,{n>wH=�d���@�JF�q	�&�#ka�}҈�Y$��gޖ�9}di�J���+��&�lG�DzĚ��辙A ND
/P 127 RD �G^aHU�+�bȆ��t���L� :����$�ozy���&l-[�?��T� ���������5m�'�R���j�lJ9���.d�k�qc�k6p�(��*bgP/_�g|���/�� ND
/o 186 RD �GEt�꽻5|F8q�	�¦H�xP���7�dܗ�����]
zΊ��X���5��>�@G�Rf�Nʐ��`���ضy̙�K�!��U�F�"<I�Tk�Sk�Jچ҆T1��3�~��������J{�
�m�:�7x`�t>��k|�C]���_��.���Bvp�����gD.�Q��I ND
/parenleft 74 RD �G���If��}�)�pBL�q������>���*eV�4k4��h|!���D)Oqf��ۤ'V��L^�31 ND
/parenright 76 RD �GP�WG�sv]+�`YM]X7�d^t2�U;_�8H������i�Af�ۚ2N/��.�u��;��ꩦ� ND
/hyphen 25 RD �G<����r��8<d >|���QP�� ND
/b 150 RD �G) "J���E����ƃ�� S�E12f��#'ձ�>�~��M(6���@�N Q�ګU7��J���s]Z[��(v�4�O������ub�S��Dj���;a�E*X�3�4J�1���"�O��კ:�:�
�0
N��K� �KAE ND
/W 55 RD �Ge�%3��5!���k����D�8�m��
!I�B	��3�$R03��T��C��7ɜ ND
/M 51 RD �GDDi�Q��  ��S�4Ov��)(*�=K�t���Y�*���X�Rk ND
/odieresis 308 RD �GEt�꽻5|F8q�	�¦H�xP���7�dܗ�����]
zΊ��X���5��>�@G�Rf�Nʐ��`���ضy̙�K�!��U�F�"<I�Tk�Sk�Jچ҆T1��3�~��������J{�
�m�:�7x`�t>��k|�C]���_��.���Bvp�����gD.�Q����MW��?�v��X�RT*^�2��ޖN�65"\x�B2N���Q65SC�n6.W���� ��_��Q�#��L�Gd1�� �)KE}��{������K	�u���AP�+�D0��\
���DC�9jG ND
/F 47 RD �G^`z�U���f�WN�#��*`g��ݭ�`� ���K�ˍ6�ƣ� ND
/U 88 RD �G��ej����_M�$u"7�Ɔ�:��gΛNԽ��2A�"�\VG�������q%��Ġ�і�4��	�:��#�9�Y�� ND
/D 154 RD �G_�2�U'v}�r(H@Q硡M.����p��x�9{�xIs1r�n̶Ut�`��N�(#Լ��B��ʹ��-rQR�y���u%�P(x��Ql��Uĭ*{��������f�N`��c�������	�S���7f��M�]'��7� ND
/C 172 RD �G0d1TQ��$M����`��r3�M��[��?�B�t�)�/���P��L�̓��p�W.+�f��Ǌ'_v��, '�+����C��1�Wm����ST7��nW:Gݒ�0��Z3et>aA�٣�$ֆ��C���.-�F���T���M�u0~-��Fџ��O!#`G�E7^ ND
/O 244 RD �G0d��F�ί�=XcMA�w��,6&d�GReS�놟�Ӌ��p,����������G��Hn�Z��U=x�tR��r���?!_��sNT��Ý�^�Rj�Q��<;�������$)�4RN��4�c�qG~'5�*����X/�T�>���z}���g�A%ɟ[b��+�IƠ�%��Qo�F��?����� �e�>n�z�[·Ű�k�'���[u�V�[ؽ}� ND
/K 54 RD �G^;���(J"����e���1+����<&��Oކ�_K֒��]��F9. ND
/N 42 RD �G_ʇq�@�o�� �~�le�A,�Q�
�>�;ǁT�� ND
/L 31 RD �G^�7&��Ow��`:����95��w ND
/germandbls 253 RD �Gik�� X�������/D���|z�D081�?��T���ˡ���c�-V�PK�}��@Cc�f@V�āP�ϱz2<��G��#�K���pu����b�۱�µ%v�ێ=6�K�ݳ:���N�wF�.����0x ��-�\���o�-jl�	 �.�L�����Y(O_�'�F��V�wO�ߣh������2!:M��N��rO�2��x���ҭ��EBÛbo�4�hB�`�2m�]I-�Nus̐�T��6���J ND
/J 85 RD �G|�����V�7�5���/{Vz�|s�y�;b������̩�&Ij�?�}�e��]p���^g:�UDh4V�\h$��E ND
/G 173 RD �G0d��QIxܝ�#s�GT�촒G�E`��̕&��|ϳع��B�-���2^i~�4W��V�N�.n'��ȿ�H�aݯ�G�:�R����!���5UW���>_��G�(��<�p�b:�l$�V�%���fʄ��ϚHo֥N�7���Gۯ���[���.� ND
endendreadonly putnoaccess putdup /FontName get exch definefont popmark currentfile closefile
