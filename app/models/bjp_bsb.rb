class BjpBsb < ActiveRecord::Base
    attr_accessible :bjp_s_1, :bjp_s_2, :bjp_s_3, :bjp_s_4, :bjp_s_5, :bjp_s_6, :bjp_s_7, :bjp_s_8, :bjp_s_9, :bjp_s_10, :bjp_s_11, :bjp_s_12, :bjp_s_13, :bjp_s_14, :bjp_s_15, :bjp_s_16, :bjp_s_17, :bjp_s_18, :bjp_s_19, :bjp_s_20,:bjp_d_21,:bjp_s_22, :bjp_s_23, :bjp_n_24, :bjp_s_25, :bjp_n_26, :bjp_s_27, :bjp_s_28, :bjp_s_29, :bjp_s_30, :bjp_s_31, :bjp_s_32, :bjp_s_33, :bjp_d_34, :bjp_s_35, :bjp_s_36, :bjp_s_37, :bjp_s_38, :bjp_s_39, :bjp_s_40, :bjp_s_41, :bjp_d_42,:bjp_d_43,:bjp_s_44, :bjp_s_45, :bjp_s_46, :bjp_s_47, :bjp_s_48, :bjp_s_49, :bjp_s_50, :bjp_s_51, :bjp_s_52, :bjp_s_53, :bjp_s_54, :bjp_s_55, :bjp_s_56, :bjp_s_57,:bjp_s_58, :bjp_s_59, :bjp_s_60, :bjp_s_61, :bjp_s_62, :bjp_s_63, :bjp_s_64, :bjp_s_65,:bjp_s_66,:bjp_s_67, :bjp_s_68, :bjp_s_69, :bjp_s_70, :bjp_s_71, :bjp_s_72, :bjp_s_73, :bjp_s_74, :bjp_s_75, :bjp_s_76, :bjp_s_77, :bjp_s_78, :bjp_s_79, :bjp_s_80, :bjp_s_81, :bjp_s_82, :bjp_s_83, :bjp_s_84, :bjp_s_85, :bjp_s_86, :bjp_s_87,:bjp_s_88,:bjp_s_89, :bjp_s_90, :bjp_s_91,:bjp_s_92,:bjp_s_93, :bjp_s_94, :bjp_d_95,:bjp_s_96,:bjp_s_97,:tname,:bjp_n_jcxcount,:bjp_s_bsfl,:bjp_s_2_1,:bjp_s_40_1,:bjp_s_110_1,
    :bjp_s_110_2,
    :bjp_s_110_3,
    :bjp_s_110_4,
    :bjp_s_110_5,
    :bjp_s_110_6,
    :bjp_s_110_7,
    :bjp_s_110_8,
    :bjp_s_111_1,
    :bjp_s_111_2,
    :bjp_s_111_3,
    :bjp_s_111_4,
    :bjp_s_111_5,
    :bjp_s_111_6,
    :bjp_s_111_7,
    :bjp_s_111_8,
    :bjp_s_112_1,
    :bjp_s_112_2,
    :bjp_s_112_3,
    :bjp_s_112_4,
    :bjp_s_112_5,
    :bjp_s_112_6,
    :bjp_s_112_7,
    :bjp_s_112_8,
    :bjp_s_113_1,
    :bjp_s_113_2,
    :bjp_s_113_3,
    :bjp_s_113_4,
    :bjp_s_113_5,
    :bjp_s_113_6,
    :bjp_s_113_7,
    :bjp_s_113_8,
    :bjp_s_114_1,
    :bjp_s_114_2,
    :bjp_s_114_3,
    :bjp_s_114_4,
    :bjp_s_114_5,
    :bjp_s_114_6,
    :bjp_s_114_7,
    :bjp_s_114_8,
    :bjp_s_115_1,
    :bjp_s_115_2,
    :bjp_s_115_3,
    :bjp_s_115_4,
    :bjp_s_115_5,
    :bjp_s_115_6,
    :bjp_s_115_7,
    :bjp_s_115_8,
    :bjp_s_116_1,
    :bjp_s_116_2,
    :bjp_s_116_3,
    :bjp_s_116_4,
    :bjp_s_116_5,
    :bjp_s_116_6,
    :bjp_s_116_7,
    :bjp_s_116_8,
    :bjp_s_117_1,
    :bjp_s_117_2,
    :bjp_s_117_3,
    :bjp_s_117_4,
    :bjp_s_117_5,
    :bjp_s_117_6,
    :bjp_s_117_7,
    :bjp_s_117_8,
    :bjp_s_118_1,
    :bjp_s_118_2,
    :bjp_s_118_3,
    :bjp_s_118_4,
    :bjp_s_118_5,
    :bjp_s_118_6,
    :bjp_s_118_7,
    :bjp_s_118_8,
    :bjp_s_119_1,
    :bjp_s_119_2,
    :bjp_s_119_3,
    :bjp_s_119_4,
    :bjp_s_119_5,
    :bjp_s_119_6,
    :bjp_s_119_7,
    :bjp_s_119_8,
    :bjp_s_120_1,
    :bjp_s_120_2,
    :bjp_s_120_3,
    :bjp_s_120_4,
    :bjp_s_120_5,
    :bjp_s_120_6,
    :bjp_s_120_7,
    :bjp_s_120_8,
    :bjp_s_121_1,
    :bjp_s_121_2,
    :bjp_s_121_3,
    :bjp_s_121_4,
    :bjp_s_121_5,
    :bjp_s_121_6,
    :bjp_s_121_7,
    :bjp_s_121_8,
    :bjp_s_122_1,
    :bjp_s_122_2,
    :bjp_s_122_3,
    :bjp_s_122_4,
    :bjp_s_122_5,
    :bjp_s_122_6,
    :bjp_s_122_7,
    :bjp_s_122_8,
    :bjp_s_123_1,
    :bjp_s_123_2,
    :bjp_s_123_3,
    :bjp_s_123_4,
    :bjp_s_123_5,
    :bjp_s_123_6,
    :bjp_s_123_7,
    :bjp_s_123_8,
    :bjp_s_124_1,
    :bjp_s_124_2,
    :bjp_s_124_3,
    :bjp_s_124_4,
    :bjp_s_124_5,
    :bjp_s_124_6,
    :bjp_s_124_7,
    :bjp_s_124_8,
    :bjp_s_125_1,
    :bjp_s_125_2,
    :bjp_s_125_3,
    :bjp_s_125_4,
    :bjp_s_125_5,
    :bjp_s_125_6,
    :bjp_s_125_7,
    :bjp_s_125_8,
    :bjp_s_126_1,
    :bjp_s_126_2,
    :bjp_s_126_3,
    :bjp_s_126_4,
    :bjp_s_126_5,
    :bjp_s_126_6,
    :bjp_s_126_7,
    :bjp_s_126_8,
    :bjp_s_127_1,
    :bjp_s_127_2,
    :bjp_s_127_3,
    :bjp_s_127_4,
    :bjp_s_127_5,
    :bjp_s_127_6,
    :bjp_s_127_7,
    :bjp_s_127_8,
    :bjp_s_128_1,
    :bjp_s_128_2,
    :bjp_s_128_3,
    :bjp_s_128_4,
    :bjp_s_128_5,
    :bjp_s_128_6,
    :bjp_s_128_7,
    :bjp_s_128_8,
    :bjp_s_129_1,
    :bjp_s_129_2,
    :bjp_s_129_3,
    :bjp_s_129_4,
    :bjp_s_129_5,
    :bjp_s_129_6,
    :bjp_s_129_7,
    :bjp_s_129_8,
    :bjp_s_130_1,
    :bjp_s_130_2,
    :bjp_s_130_3,
    :bjp_s_130_4,
    :bjp_s_130_5,
    :bjp_s_130_6,
    :bjp_s_130_7,
    :bjp_s_130_8,
    :bjp_s_131_1,
    :bjp_s_131_2,
    :bjp_s_131_3,
    :bjp_s_131_4,
    :bjp_s_131_5,
    :bjp_s_131_6,
    :bjp_s_131_7,
    :bjp_s_131_8,
    :bjp_s_132_1,
    :bjp_s_132_2,
    :bjp_s_132_3,
    :bjp_s_132_4,
    :bjp_s_132_5,
    :bjp_s_132_6,
    :bjp_s_132_7,
    :bjp_s_132_8,
    :bjp_s_133_1,
    :bjp_s_133_2,
    :bjp_s_133_3,
    :bjp_s_133_4,
    :bjp_s_133_5,
    :bjp_s_133_6,
    :bjp_s_133_7,
    :bjp_s_133_8,
    :bjp_s_134_1,
    :bjp_s_134_2,
    :bjp_s_134_3,
    :bjp_s_134_4,
    :bjp_s_134_5,
    :bjp_s_134_6,
    :bjp_s_134_7,
    :bjp_s_134_8,
    :bjp_s_135_1,
    :bjp_s_135_2,
    :bjp_s_135_3,
    :bjp_s_135_4,
    :bjp_s_135_5,
    :bjp_s_135_6,
    :bjp_s_135_7,
    :bjp_s_135_8,
    :bjp_s_136_1,
    :bjp_s_136_2,
    :bjp_s_136_3,
    :bjp_s_136_4,
    :bjp_s_136_5,
    :bjp_s_136_6,
    :bjp_s_136_7,
    :bjp_s_136_8,
    :bjp_s_137_1,
    :bjp_s_137_2,
    :bjp_s_137_3,
    :bjp_s_137_4,
    :bjp_s_137_5,
    :bjp_s_137_6,
    :bjp_s_137_7,
    :bjp_s_137_8,
    :bjp_s_138_1,
    :bjp_s_138_2,
    :bjp_s_138_3,
    :bjp_s_138_4,
    :bjp_s_138_5,
    :bjp_s_138_6,
    :bjp_s_138_7,
    :bjp_s_138_8,
    :bjp_s_139_1,
    :bjp_s_139_2,
    :bjp_s_139_3,
    :bjp_s_139_4,
    :bjp_s_139_5,
    :bjp_s_139_6,
    :bjp_s_139_7,
    :bjp_s_139_8,
    :bjp_s_140_1,
    :bjp_s_140_2,
    :bjp_s_140_3,
    :bjp_s_140_4,
    :bjp_s_140_5,
    :bjp_s_140_6,
    :bjp_s_140_7,
    :bjp_s_140_8,
    
    :bjp_s_110_9,
    :bjp_s_111_9,
    :bjp_s_112_9,
    :bjp_s_113_9,
    :bjp_s_114_9,
    :bjp_s_115_9,
    :bjp_s_116_9,
    :bjp_s_117_9,
    :bjp_s_118_9,
    :bjp_s_119_9,
    :bjp_s_120_9,
    :bjp_s_121_9,
    :bjp_s_122_9,
    :bjp_s_123_9,
    :bjp_s_124_9,
    :bjp_s_125_9,
    :bjp_s_126_9,
    :bjp_s_127_9,
    :bjp_s_128_9,
    :bjp_s_129_9,
    :bjp_s_130_9,
    :bjp_s_131_9,
    :bjp_s_132_9,
    :bjp_s_133_9,
    :bjp_s_134_9,
    :bjp_s_135_9,
    :bjp_s_136_9,
    :bjp_s_137_9,
    :bjp_s_138_9,
    :bjp_s_139_9,
    :bjp_s_140_9,
    :bjp_s_110_0,
    :bjp_s_111_0,
    :bjp_s_112_0,
    :bjp_s_113_0,
    :bjp_s_114_0,
    :bjp_s_115_0,
    :bjp_s_116_0,
    :bjp_s_117_0,
    :bjp_s_118_0,
    :bjp_s_119_0,
    :bjp_s_120_0,
    :bjp_s_121_0,
    :bjp_s_122_0,
    :bjp_s_123_0,
    :bjp_s_124_0,
    :bjp_s_125_0,
    :bjp_s_126_0,
    :bjp_s_127_0,
    :bjp_s_128_0,
    :bjp_s_129_0,
    :bjp_s_130_0,
    :bjp_s_131_0,
    :bjp_s_132_0,
    :bjp_s_133_0,
    :bjp_s_134_0,
    :bjp_s_135_0,
    :bjp_s_136_0,
    :bjp_s_137_0,
    :bjp_s_138_0,
    :bjp_s_139_0,
    :bjp_s_140_0,
    :bjp_s_110_10,
    :bjp_s_111_10,
    :bjp_s_112_10,
    :bjp_s_113_10,
    :bjp_s_114_10,
    :bjp_s_115_10,
    :bjp_s_116_10,
    :bjp_s_117_10,
    :bjp_s_118_10,
    :bjp_s_119_10,
    :bjp_s_120_10,
    :bjp_s_121_10,
    :bjp_s_122_10,
    :bjp_s_123_10,
    :bjp_s_124_10,
    :bjp_s_125_10,
    :bjp_s_126_10,
    :bjp_s_127_10,
    :bjp_s_128_10,
    :bjp_s_129_10,
    :bjp_s_130_10,
    :bjp_s_131_10,
    :bjp_s_132_10,
    :bjp_s_133_10,
    :bjp_s_134_10,
    :bjp_s_135_10,
    :bjp_s_136_10,
    :bjp_s_137_10,
    :bjp_s_138_10,
    :bjp_s_139_10,
    :bjp_s_140_10,
    :bjp_i_state
    has_many :bjpdata, :dependent => :delete_all

    
    
    
    


end
