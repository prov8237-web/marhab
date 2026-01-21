package lime.graphics.opengl
{
   import haxe._Int64.___Int64;
   import haxe.io.Bytes;
   import lime.utils.ArrayBufferView;
   import lime.utils.BytePointerData;
   
   public class GL
   {
      
      public static var DEPTH_BUFFER_BIT:int;
      
      public static var STENCIL_BUFFER_BIT:int;
      
      public static var COLOR_BUFFER_BIT:int;
      
      public static var POINTS:int;
      
      public static var LINES:int;
      
      public static var LINE_LOOP:int;
      
      public static var LINE_STRIP:int;
      
      public static var TRIANGLES:int;
      
      public static var TRIANGLE_STRIP:int;
      
      public static var TRIANGLE_FAN:int;
      
      public static var ZERO:int;
      
      public static var ONE:int;
      
      public static var SRC_COLOR:int;
      
      public static var ONE_MINUS_SRC_COLOR:int;
      
      public static var SRC_ALPHA:int;
      
      public static var ONE_MINUS_SRC_ALPHA:int;
      
      public static var DST_ALPHA:int;
      
      public static var ONE_MINUS_DST_ALPHA:int;
      
      public static var DST_COLOR:int;
      
      public static var ONE_MINUS_DST_COLOR:int;
      
      public static var SRC_ALPHA_SATURATE:int;
      
      public static var FUNC_ADD:int;
      
      public static var BLEND_EQUATION:int;
      
      public static var BLEND_EQUATION_RGB:int;
      
      public static var BLEND_EQUATION_ALPHA:int;
      
      public static var FUNC_SUBTRACT:int;
      
      public static var FUNC_REVERSE_SUBTRACT:int;
      
      public static var BLEND_DST_RGB:int;
      
      public static var BLEND_SRC_RGB:int;
      
      public static var BLEND_DST_ALPHA:int;
      
      public static var BLEND_SRC_ALPHA:int;
      
      public static var CONSTANT_COLOR:int;
      
      public static var ONE_MINUS_CONSTANT_COLOR:int;
      
      public static var CONSTANT_ALPHA:int;
      
      public static var ONE_MINUS_CONSTANT_ALPHA:int;
      
      public static var BLEND_COLOR:int;
      
      public static var ARRAY_BUFFER:int;
      
      public static var ELEMENT_ARRAY_BUFFER:int;
      
      public static var ARRAY_BUFFER_BINDING:int;
      
      public static var ELEMENT_ARRAY_BUFFER_BINDING:int;
      
      public static var STREAM_DRAW:int;
      
      public static var STATIC_DRAW:int;
      
      public static var DYNAMIC_DRAW:int;
      
      public static var BUFFER_SIZE:int;
      
      public static var BUFFER_USAGE:int;
      
      public static var CURRENT_VERTEX_ATTRIB:int;
      
      public static var FRONT:int;
      
      public static var BACK:int;
      
      public static var FRONT_AND_BACK:int;
      
      public static var CULL_FACE:int;
      
      public static var BLEND:int;
      
      public static var DITHER:int;
      
      public static var STENCIL_TEST:int;
      
      public static var DEPTH_TEST:int;
      
      public static var SCISSOR_TEST:int;
      
      public static var POLYGON_OFFSET_FILL:int;
      
      public static var SAMPLE_ALPHA_TO_COVERAGE:int;
      
      public static var SAMPLE_COVERAGE:int;
      
      public static var NO_ERROR:int;
      
      public static var INVALID_ENUM:int;
      
      public static var INVALID_VALUE:int;
      
      public static var INVALID_OPERATION:int;
      
      public static var OUT_OF_MEMORY:int;
      
      public static var CW:int;
      
      public static var CCW:int;
      
      public static var LINE_WIDTH:int;
      
      public static var ALIASED_POINT_SIZE_RANGE:int;
      
      public static var ALIASED_LINE_WIDTH_RANGE:int;
      
      public static var CULL_FACE_MODE:int;
      
      public static var FRONT_FACE:int;
      
      public static var DEPTH_RANGE:int;
      
      public static var DEPTH_WRITEMASK:int;
      
      public static var DEPTH_CLEAR_VALUE:int;
      
      public static var DEPTH_FUNC:int;
      
      public static var STENCIL_CLEAR_VALUE:int;
      
      public static var STENCIL_FUNC:int;
      
      public static var STENCIL_FAIL:int;
      
      public static var STENCIL_PASS_DEPTH_FAIL:int;
      
      public static var STENCIL_PASS_DEPTH_PASS:int;
      
      public static var STENCIL_REF:int;
      
      public static var STENCIL_VALUE_MASK:int;
      
      public static var STENCIL_WRITEMASK:int;
      
      public static var STENCIL_BACK_FUNC:int;
      
      public static var STENCIL_BACK_FAIL:int;
      
      public static var STENCIL_BACK_PASS_DEPTH_FAIL:int;
      
      public static var STENCIL_BACK_PASS_DEPTH_PASS:int;
      
      public static var STENCIL_BACK_REF:int;
      
      public static var STENCIL_BACK_VALUE_MASK:int;
      
      public static var STENCIL_BACK_WRITEMASK:int;
      
      public static var VIEWPORT:int;
      
      public static var SCISSOR_BOX:int;
      
      public static var COLOR_CLEAR_VALUE:int;
      
      public static var COLOR_WRITEMASK:int;
      
      public static var UNPACK_ALIGNMENT:int;
      
      public static var PACK_ALIGNMENT:int;
      
      public static var MAX_TEXTURE_SIZE:int;
      
      public static var MAX_VIEWPORT_DIMS:int;
      
      public static var SUBPIXEL_BITS:int;
      
      public static var RED_BITS:int;
      
      public static var GREEN_BITS:int;
      
      public static var BLUE_BITS:int;
      
      public static var ALPHA_BITS:int;
      
      public static var DEPTH_BITS:int;
      
      public static var STENCIL_BITS:int;
      
      public static var POLYGON_OFFSET_UNITS:int;
      
      public static var POLYGON_OFFSET_FACTOR:int;
      
      public static var TEXTURE_BINDING_2D:int;
      
      public static var SAMPLE_BUFFERS:int;
      
      public static var SAMPLES:int;
      
      public static var SAMPLE_COVERAGE_VALUE:int;
      
      public static var SAMPLE_COVERAGE_INVERT:int;
      
      public static var NUM_COMPRESSED_TEXTURE_FORMATS:int;
      
      public static var COMPRESSED_TEXTURE_FORMATS:int;
      
      public static var DONT_CARE:int;
      
      public static var FASTEST:int;
      
      public static var NICEST:int;
      
      public static var GENERATE_MIPMAP_HINT:int;
      
      public static var BYTE:int;
      
      public static var UNSIGNED_BYTE:int;
      
      public static var SHORT:int;
      
      public static var UNSIGNED_SHORT:int;
      
      public static var INT:int;
      
      public static var UNSIGNED_INT:int;
      
      public static var FLOAT:int;
      
      public static var DEPTH_COMPONENT:int;
      
      public static var ALPHA:int;
      
      public static var RGB:int;
      
      public static var RGBA:int;
      
      public static var LUMINANCE:int;
      
      public static var LUMINANCE_ALPHA:int;
      
      public static var UNSIGNED_SHORT_4_4_4_4:int;
      
      public static var UNSIGNED_SHORT_5_5_5_1:int;
      
      public static var UNSIGNED_SHORT_5_6_5:int;
      
      public static var FRAGMENT_SHADER:int;
      
      public static var VERTEX_SHADER:int;
      
      public static var MAX_VERTEX_ATTRIBS:int;
      
      public static var MAX_VERTEX_UNIFORM_VECTORS:int;
      
      public static var MAX_VARYING_VECTORS:int;
      
      public static var MAX_COMBINED_TEXTURE_IMAGE_UNITS:int;
      
      public static var MAX_VERTEX_TEXTURE_IMAGE_UNITS:int;
      
      public static var MAX_TEXTURE_IMAGE_UNITS:int;
      
      public static var MAX_FRAGMENT_UNIFORM_VECTORS:int;
      
      public static var SHADER_TYPE:int;
      
      public static var DELETE_STATUS:int;
      
      public static var LINK_STATUS:int;
      
      public static var VALIDATE_STATUS:int;
      
      public static var ATTACHED_SHADERS:int;
      
      public static var ACTIVE_UNIFORMS:int;
      
      public static var ACTIVE_ATTRIBUTES:int;
      
      public static var SHADING_LANGUAGE_VERSION:int;
      
      public static var CURRENT_PROGRAM:int;
      
      public static var NEVER:int;
      
      public static var LESS:int;
      
      public static var EQUAL:int;
      
      public static var LEQUAL:int;
      
      public static var GREATER:int;
      
      public static var NOTEQUAL:int;
      
      public static var GEQUAL:int;
      
      public static var ALWAYS:int;
      
      public static var KEEP:int;
      
      public static var REPLACE:int;
      
      public static var INCR:int;
      
      public static var DECR:int;
      
      public static var INVERT:int;
      
      public static var INCR_WRAP:int;
      
      public static var DECR_WRAP:int;
      
      public static var VENDOR:int;
      
      public static var RENDERER:int;
      
      public static var VERSION:int;
      
      public static var EXTENSIONS:int;
      
      public static var NEAREST:int;
      
      public static var LINEAR:int;
      
      public static var NEAREST_MIPMAP_NEAREST:int;
      
      public static var LINEAR_MIPMAP_NEAREST:int;
      
      public static var NEAREST_MIPMAP_LINEAR:int;
      
      public static var LINEAR_MIPMAP_LINEAR:int;
      
      public static var TEXTURE_MAG_FILTER:int;
      
      public static var TEXTURE_MIN_FILTER:int;
      
      public static var TEXTURE_WRAP_S:int;
      
      public static var TEXTURE_WRAP_T:int;
      
      public static var TEXTURE_2D:int;
      
      public static var TEXTURE:int;
      
      public static var TEXTURE_CUBE_MAP:int;
      
      public static var TEXTURE_BINDING_CUBE_MAP:int;
      
      public static var TEXTURE_CUBE_MAP_POSITIVE_X:int;
      
      public static var TEXTURE_CUBE_MAP_NEGATIVE_X:int;
      
      public static var TEXTURE_CUBE_MAP_POSITIVE_Y:int;
      
      public static var TEXTURE_CUBE_MAP_NEGATIVE_Y:int;
      
      public static var TEXTURE_CUBE_MAP_POSITIVE_Z:int;
      
      public static var TEXTURE_CUBE_MAP_NEGATIVE_Z:int;
      
      public static var MAX_CUBE_MAP_TEXTURE_SIZE:int;
      
      public static var TEXTURE0:int;
      
      public static var TEXTURE1:int;
      
      public static var TEXTURE2:int;
      
      public static var TEXTURE3:int;
      
      public static var TEXTURE4:int;
      
      public static var TEXTURE5:int;
      
      public static var TEXTURE6:int;
      
      public static var TEXTURE7:int;
      
      public static var TEXTURE8:int;
      
      public static var TEXTURE9:int;
      
      public static var TEXTURE10:int;
      
      public static var TEXTURE11:int;
      
      public static var TEXTURE12:int;
      
      public static var TEXTURE13:int;
      
      public static var TEXTURE14:int;
      
      public static var TEXTURE15:int;
      
      public static var TEXTURE16:int;
      
      public static var TEXTURE17:int;
      
      public static var TEXTURE18:int;
      
      public static var TEXTURE19:int;
      
      public static var TEXTURE20:int;
      
      public static var TEXTURE21:int;
      
      public static var TEXTURE22:int;
      
      public static var TEXTURE23:int;
      
      public static var TEXTURE24:int;
      
      public static var TEXTURE25:int;
      
      public static var TEXTURE26:int;
      
      public static var TEXTURE27:int;
      
      public static var TEXTURE28:int;
      
      public static var TEXTURE29:int;
      
      public static var TEXTURE30:int;
      
      public static var TEXTURE31:int;
      
      public static var ACTIVE_TEXTURE:int;
      
      public static var REPEAT:int;
      
      public static var CLAMP_TO_EDGE:int;
      
      public static var MIRRORED_REPEAT:int;
      
      public static var FLOAT_VEC2:int;
      
      public static var FLOAT_VEC3:int;
      
      public static var FLOAT_VEC4:int;
      
      public static var INT_VEC2:int;
      
      public static var INT_VEC3:int;
      
      public static var INT_VEC4:int;
      
      public static var BOOL:int;
      
      public static var BOOL_VEC2:int;
      
      public static var BOOL_VEC3:int;
      
      public static var BOOL_VEC4:int;
      
      public static var FLOAT_MAT2:int;
      
      public static var FLOAT_MAT3:int;
      
      public static var FLOAT_MAT4:int;
      
      public static var SAMPLER_2D:int;
      
      public static var SAMPLER_CUBE:int;
      
      public static var VERTEX_ATTRIB_ARRAY_ENABLED:int;
      
      public static var VERTEX_ATTRIB_ARRAY_SIZE:int;
      
      public static var VERTEX_ATTRIB_ARRAY_STRIDE:int;
      
      public static var VERTEX_ATTRIB_ARRAY_TYPE:int;
      
      public static var VERTEX_ATTRIB_ARRAY_NORMALIZED:int;
      
      public static var VERTEX_ATTRIB_ARRAY_POINTER:int;
      
      public static var VERTEX_ATTRIB_ARRAY_BUFFER_BINDING:int;
      
      public static var IMPLEMENTATION_COLOR_READ_TYPE:int;
      
      public static var IMPLEMENTATION_COLOR_READ_FORMAT:int;
      
      public static var VERTEX_PROGRAM_POINT_SIZE:int;
      
      public static var POINT_SPRITE:int;
      
      public static var COMPILE_STATUS:int;
      
      public static var LOW_FLOAT:int;
      
      public static var MEDIUM_FLOAT:int;
      
      public static var HIGH_FLOAT:int;
      
      public static var LOW_INT:int;
      
      public static var MEDIUM_INT:int;
      
      public static var HIGH_INT:int;
      
      public static var FRAMEBUFFER:int;
      
      public static var RENDERBUFFER:int;
      
      public static var RGBA4:int;
      
      public static var RGB5_A1:int;
      
      public static var RGB565:int;
      
      public static var DEPTH_COMPONENT16:int;
      
      public static var STENCIL_INDEX:int;
      
      public static var STENCIL_INDEX8:int;
      
      public static var DEPTH_STENCIL:int;
      
      public static var RENDERBUFFER_WIDTH:int;
      
      public static var RENDERBUFFER_HEIGHT:int;
      
      public static var RENDERBUFFER_INTERNAL_FORMAT:int;
      
      public static var RENDERBUFFER_RED_SIZE:int;
      
      public static var RENDERBUFFER_GREEN_SIZE:int;
      
      public static var RENDERBUFFER_BLUE_SIZE:int;
      
      public static var RENDERBUFFER_ALPHA_SIZE:int;
      
      public static var RENDERBUFFER_DEPTH_SIZE:int;
      
      public static var RENDERBUFFER_STENCIL_SIZE:int;
      
      public static var FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE:int;
      
      public static var FRAMEBUFFER_ATTACHMENT_OBJECT_NAME:int;
      
      public static var FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL:int;
      
      public static var FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE:int;
      
      public static var COLOR_ATTACHMENT0:int;
      
      public static var DEPTH_ATTACHMENT:int;
      
      public static var STENCIL_ATTACHMENT:int;
      
      public static var DEPTH_STENCIL_ATTACHMENT:int;
      
      public static var NONE:int;
      
      public static var FRAMEBUFFER_COMPLETE:int;
      
      public static var FRAMEBUFFER_INCOMPLETE_ATTACHMENT:int;
      
      public static var FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:int;
      
      public static var FRAMEBUFFER_INCOMPLETE_DIMENSIONS:int;
      
      public static var FRAMEBUFFER_UNSUPPORTED:int;
      
      public static var FRAMEBUFFER_BINDING:int;
      
      public static var RENDERBUFFER_BINDING:int;
      
      public static var MAX_RENDERBUFFER_SIZE:int;
      
      public static var INVALID_FRAMEBUFFER_OPERATION:int;
      
      public static var UNPACK_FLIP_Y_WEBGL:int;
      
      public static var UNPACK_PREMULTIPLY_ALPHA_WEBGL:int;
      
      public static var CONTEXT_LOST_WEBGL:int;
      
      public static var UNPACK_COLORSPACE_CONVERSION_WEBGL:int;
      
      public static var BROWSER_DEFAULT_WEBGL:int;
      
      public static var READ_BUFFER:int;
      
      public static var UNPACK_ROW_LENGTH:int;
      
      public static var UNPACK_SKIP_ROWS:int;
      
      public static var UNPACK_SKIP_PIXELS:int;
      
      public static var PACK_ROW_LENGTH:int;
      
      public static var PACK_SKIP_ROWS:int;
      
      public static var PACK_SKIP_PIXELS:int;
      
      public static var TEXTURE_BINDING_3D:int;
      
      public static var UNPACK_SKIP_IMAGES:int;
      
      public static var UNPACK_IMAGE_HEIGHT:int;
      
      public static var MAX_3D_TEXTURE_SIZE:int;
      
      public static var MAX_ELEMENTS_VERTICES:int;
      
      public static var MAX_ELEMENTS_INDICES:int;
      
      public static var MAX_TEXTURE_LOD_BIAS:int;
      
      public static var MAX_FRAGMENT_UNIFORM_COMPONENTS:int;
      
      public static var MAX_VERTEX_UNIFORM_COMPONENTS:int;
      
      public static var MAX_ARRAY_TEXTURE_LAYERS:int;
      
      public static var MIN_PROGRAM_TEXEL_OFFSET:int;
      
      public static var MAX_PROGRAM_TEXEL_OFFSET:int;
      
      public static var MAX_VARYING_COMPONENTS:int;
      
      public static var FRAGMENT_SHADER_DERIVATIVE_HINT:int;
      
      public static var RASTERIZER_DISCARD:int;
      
      public static var VERTEX_ARRAY_BINDING:int;
      
      public static var MAX_VERTEX_OUTPUT_COMPONENTS:int;
      
      public static var MAX_FRAGMENT_INPUT_COMPONENTS:int;
      
      public static var MAX_SERVER_WAIT_TIMEOUT:int;
      
      public static var MAX_ELEMENT_INDEX:int;
      
      public static var RED:int;
      
      public static var RGB8:int;
      
      public static var RGBA8:int;
      
      public static var RGB10_A2:int;
      
      public static var TEXTURE_3D:int;
      
      public static var TEXTURE_WRAP_R:int;
      
      public static var TEXTURE_MIN_LOD:int;
      
      public static var TEXTURE_MAX_LOD:int;
      
      public static var TEXTURE_BASE_LEVEL:int;
      
      public static var TEXTURE_MAX_LEVEL:int;
      
      public static var TEXTURE_COMPARE_MODE:int;
      
      public static var TEXTURE_COMPARE_FUNC:int;
      
      public static var SRGB:int;
      
      public static var SRGB8:int;
      
      public static var SRGB8_ALPHA8:int;
      
      public static var COMPARE_REF_TO_TEXTURE:int;
      
      public static var RGBA32F:int;
      
      public static var RGB32F:int;
      
      public static var RGBA16F:int;
      
      public static var RGB16F:int;
      
      public static var TEXTURE_2D_ARRAY:int;
      
      public static var TEXTURE_BINDING_2D_ARRAY:int;
      
      public static var R11F_G11F_B10F:int;
      
      public static var RGB9_E5:int;
      
      public static var RGBA32UI:int;
      
      public static var RGB32UI:int;
      
      public static var RGBA16UI:int;
      
      public static var RGB16UI:int;
      
      public static var RGBA8UI:int;
      
      public static var RGB8UI:int;
      
      public static var RGBA32I:int;
      
      public static var RGB32I:int;
      
      public static var RGBA16I:int;
      
      public static var RGB16I:int;
      
      public static var RGBA8I:int;
      
      public static var RGB8I:int;
      
      public static var RED_INTEGER:int;
      
      public static var RGB_INTEGER:int;
      
      public static var RGBA_INTEGER:int;
      
      public static var R8:int;
      
      public static var RG8:int;
      
      public static var R16F:int;
      
      public static var R32F:int;
      
      public static var RG16F:int;
      
      public static var RG32F:int;
      
      public static var R8I:int;
      
      public static var R8UI:int;
      
      public static var R16I:int;
      
      public static var R16UI:int;
      
      public static var R32I:int;
      
      public static var R32UI:int;
      
      public static var RG8I:int;
      
      public static var RG8UI:int;
      
      public static var RG16I:int;
      
      public static var RG16UI:int;
      
      public static var RG32I:int;
      
      public static var RG32UI:int;
      
      public static var R8_SNORM:int;
      
      public static var RG8_SNORM:int;
      
      public static var RGB8_SNORM:int;
      
      public static var RGBA8_SNORM:int;
      
      public static var RGB10_A2UI:int;
      
      public static var TEXTURE_IMMUTABLE_FORMAT:int;
      
      public static var TEXTURE_IMMUTABLE_LEVELS:int;
      
      public static var UNSIGNED_INT_2_10_10_10_REV:int;
      
      public static var UNSIGNED_INT_10F_11F_11F_REV:int;
      
      public static var UNSIGNED_INT_5_9_9_9_REV:int;
      
      public static var FLOAT_32_UNSIGNED_INT_24_8_REV:int;
      
      public static var UNSIGNED_INT_24_8:int;
      
      public static var HALF_FLOAT:int;
      
      public static var RG:int;
      
      public static var RG_INTEGER:int;
      
      public static var INT_2_10_10_10_REV:int;
      
      public static var CURRENT_QUERY:int;
      
      public static var QUERY_RESULT:int;
      
      public static var QUERY_RESULT_AVAILABLE:int;
      
      public static var ANY_SAMPLES_PASSED:int;
      
      public static var ANY_SAMPLES_PASSED_CONSERVATIVE:int;
      
      public static var MAX_DRAW_BUFFERS:int;
      
      public static var DRAW_BUFFER0:int;
      
      public static var DRAW_BUFFER1:int;
      
      public static var DRAW_BUFFER2:int;
      
      public static var DRAW_BUFFER3:int;
      
      public static var DRAW_BUFFER4:int;
      
      public static var DRAW_BUFFER5:int;
      
      public static var DRAW_BUFFER6:int;
      
      public static var DRAW_BUFFER7:int;
      
      public static var DRAW_BUFFER8:int;
      
      public static var DRAW_BUFFER9:int;
      
      public static var DRAW_BUFFER10:int;
      
      public static var DRAW_BUFFER11:int;
      
      public static var DRAW_BUFFER12:int;
      
      public static var DRAW_BUFFER13:int;
      
      public static var DRAW_BUFFER14:int;
      
      public static var DRAW_BUFFER15:int;
      
      public static var MAX_COLOR_ATTACHMENTS:int;
      
      public static var COLOR_ATTACHMENT1:int;
      
      public static var COLOR_ATTACHMENT2:int;
      
      public static var COLOR_ATTACHMENT3:int;
      
      public static var COLOR_ATTACHMENT4:int;
      
      public static var COLOR_ATTACHMENT5:int;
      
      public static var COLOR_ATTACHMENT6:int;
      
      public static var COLOR_ATTACHMENT7:int;
      
      public static var COLOR_ATTACHMENT8:int;
      
      public static var COLOR_ATTACHMENT9:int;
      
      public static var COLOR_ATTACHMENT10:int;
      
      public static var COLOR_ATTACHMENT11:int;
      
      public static var COLOR_ATTACHMENT12:int;
      
      public static var COLOR_ATTACHMENT13:int;
      
      public static var COLOR_ATTACHMENT14:int;
      
      public static var COLOR_ATTACHMENT15:int;
      
      public static var SAMPLER_3D:int;
      
      public static var SAMPLER_2D_SHADOW:int;
      
      public static var SAMPLER_2D_ARRAY:int;
      
      public static var SAMPLER_2D_ARRAY_SHADOW:int;
      
      public static var SAMPLER_CUBE_SHADOW:int;
      
      public static var INT_SAMPLER_2D:int;
      
      public static var INT_SAMPLER_3D:int;
      
      public static var INT_SAMPLER_CUBE:int;
      
      public static var INT_SAMPLER_2D_ARRAY:int;
      
      public static var UNSIGNED_INT_SAMPLER_2D:int;
      
      public static var UNSIGNED_INT_SAMPLER_3D:int;
      
      public static var UNSIGNED_INT_SAMPLER_CUBE:int;
      
      public static var UNSIGNED_INT_SAMPLER_2D_ARRAY:int;
      
      public static var MAX_SAMPLES:int;
      
      public static var SAMPLER_BINDING:int;
      
      public static var PIXEL_PACK_BUFFER:int;
      
      public static var PIXEL_UNPACK_BUFFER:int;
      
      public static var PIXEL_PACK_BUFFER_BINDING:int;
      
      public static var PIXEL_UNPACK_BUFFER_BINDING:int;
      
      public static var COPY_READ_BUFFER:int;
      
      public static var COPY_WRITE_BUFFER:int;
      
      public static var COPY_READ_BUFFER_BINDING:int;
      
      public static var COPY_WRITE_BUFFER_BINDING:int;
      
      public static var FLOAT_MAT2x3:int;
      
      public static var FLOAT_MAT2x4:int;
      
      public static var FLOAT_MAT3x2:int;
      
      public static var FLOAT_MAT3x4:int;
      
      public static var FLOAT_MAT4x2:int;
      
      public static var FLOAT_MAT4x3:int;
      
      public static var UNSIGNED_INT_VEC2:int;
      
      public static var UNSIGNED_INT_VEC3:int;
      
      public static var UNSIGNED_INT_VEC4:int;
      
      public static var UNSIGNED_NORMALIZED:int;
      
      public static var SIGNED_NORMALIZED:int;
      
      public static var VERTEX_ATTRIB_ARRAY_INTEGER:int;
      
      public static var VERTEX_ATTRIB_ARRAY_DIVISOR:int;
      
      public static var TRANSFORM_FEEDBACK_BUFFER_MODE:int;
      
      public static var MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS:int;
      
      public static var TRANSFORM_FEEDBACK_VARYINGS:int;
      
      public static var TRANSFORM_FEEDBACK_BUFFER_START:int;
      
      public static var TRANSFORM_FEEDBACK_BUFFER_SIZE:int;
      
      public static var TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN:int;
      
      public static var MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS:int;
      
      public static var MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS:int;
      
      public static var INTERLEAVED_ATTRIBS:int;
      
      public static var SEPARATE_ATTRIBS:int;
      
      public static var TRANSFORM_FEEDBACK_BUFFER:int;
      
      public static var TRANSFORM_FEEDBACK_BUFFER_BINDING:int;
      
      public static var TRANSFORM_FEEDBACK:int;
      
      public static var TRANSFORM_FEEDBACK_PAUSED:int;
      
      public static var TRANSFORM_FEEDBACK_ACTIVE:int;
      
      public static var TRANSFORM_FEEDBACK_BINDING:int;
      
      public static var FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING:int;
      
      public static var FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE:int;
      
      public static var FRAMEBUFFER_ATTACHMENT_RED_SIZE:int;
      
      public static var FRAMEBUFFER_ATTACHMENT_GREEN_SIZE:int;
      
      public static var FRAMEBUFFER_ATTACHMENT_BLUE_SIZE:int;
      
      public static var FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE:int;
      
      public static var FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE:int;
      
      public static var FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE:int;
      
      public static var FRAMEBUFFER_DEFAULT:int;
      
      public static var DEPTH24_STENCIL8:int;
      
      public static var DRAW_FRAMEBUFFER_BINDING:int;
      
      public static var READ_FRAMEBUFFER:int;
      
      public static var DRAW_FRAMEBUFFER:int;
      
      public static var READ_FRAMEBUFFER_BINDING:int;
      
      public static var RENDERBUFFER_SAMPLES:int;
      
      public static var FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER:int;
      
      public static var FRAMEBUFFER_INCOMPLETE_MULTISAMPLE:int;
      
      public static var UNIFORM_BUFFER:int;
      
      public static var UNIFORM_BUFFER_BINDING:int;
      
      public static var UNIFORM_BUFFER_START:int;
      
      public static var UNIFORM_BUFFER_SIZE:int;
      
      public static var MAX_VERTEX_UNIFORM_BLOCKS:int;
      
      public static var MAX_FRAGMENT_UNIFORM_BLOCKS:int;
      
      public static var MAX_COMBINED_UNIFORM_BLOCKS:int;
      
      public static var MAX_UNIFORM_BUFFER_BINDINGS:int;
      
      public static var MAX_UNIFORM_BLOCK_SIZE:int;
      
      public static var MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS:int;
      
      public static var MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS:int;
      
      public static var UNIFORM_BUFFER_OFFSET_ALIGNMENT:int;
      
      public static var ACTIVE_UNIFORM_BLOCKS:int;
      
      public static var UNIFORM_TYPE:int;
      
      public static var UNIFORM_SIZE:int;
      
      public static var UNIFORM_BLOCK_INDEX:int;
      
      public static var UNIFORM_OFFSET:int;
      
      public static var UNIFORM_ARRAY_STRIDE:int;
      
      public static var UNIFORM_MATRIX_STRIDE:int;
      
      public static var UNIFORM_IS_ROW_MAJOR:int;
      
      public static var UNIFORM_BLOCK_BINDING:int;
      
      public static var UNIFORM_BLOCK_DATA_SIZE:int;
      
      public static var UNIFORM_BLOCK_ACTIVE_UNIFORMS:int;
      
      public static var UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES:int;
      
      public static var UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER:int;
      
      public static var UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER:int;
      
      public static var OBJECT_TYPE:int;
      
      public static var SYNC_CONDITION:int;
      
      public static var SYNC_STATUS:int;
      
      public static var SYNC_FLAGS:int;
      
      public static var SYNC_FENCE:int;
      
      public static var SYNC_GPU_COMMANDS_COMPLETE:int;
      
      public static var UNSIGNALED:int;
      
      public static var SIGNALED:int;
      
      public static var ALREADY_SIGNALED:int;
      
      public static var TIMEOUT_EXPIRED:int;
      
      public static var CONDITION_SATISFIED:int;
      
      public static var WAIT_FAILED:int;
      
      public static var SYNC_FLUSH_COMMANDS_BIT:int;
      
      public static var COLOR:int;
      
      public static var DEPTH:int;
      
      public static var STENCIL:int;
      
      public static var MIN:int;
      
      public static var MAX:int;
      
      public static var DEPTH_COMPONENT24:int;
      
      public static var STREAM_READ:int;
      
      public static var STREAM_COPY:int;
      
      public static var STATIC_READ:int;
      
      public static var STATIC_COPY:int;
      
      public static var DYNAMIC_READ:int;
      
      public static var DYNAMIC_COPY:int;
      
      public static var DEPTH_COMPONENT32F:int;
      
      public static var DEPTH32F_STENCIL8:int;
      
      public static var INVALID_INDEX:int;
      
      public static var TIMEOUT_IGNORED:int;
      
      public static var MAX_CLIENT_WAIT_TIMEOUT_WEBGL:int;
      
      public static var context:*;
      
      public static var type:String;
      
      public static var version:Number;
       
      
      public function GL()
      {
      }
      
      public static function activeTexture(param1:int) : void
      {
         GL.context.activeTexture(param1);
      }
      
      public static function attachShader(param1:GLObject, param2:GLObject) : void
      {
         GL.context.attachShader(param1,param2);
      }
      
      public static function beginQuery(param1:int, param2:GLObject) : void
      {
         GL.context.beginQuery(param1,param2);
      }
      
      public static function beginTransformFeedback(param1:int) : void
      {
         GL.context.beginTransformFeedback(param1);
      }
      
      public static function bindAttribLocation(param1:GLObject, param2:int, param3:String) : void
      {
         GL.context.bindAttribLocation(param1,param2,param3);
      }
      
      public static function bindBuffer(param1:int, param2:GLObject) : void
      {
         GL.context.bindBuffer(param1,param2);
      }
      
      public static function bindBufferBase(param1:int, param2:int, param3:GLObject) : void
      {
         GL.context.bindBufferBase(param1,param2,param3);
      }
      
      public static function bindBufferRange(param1:int, param2:int, param3:GLObject, param4:int, param5:int) : void
      {
         GL.context.bindBufferRange(param1,param2,param3,param4,param5);
      }
      
      public static function bindFramebuffer(param1:int, param2:GLObject) : void
      {
         GL.context.bindFramebuffer(param1,param2);
      }
      
      public static function bindRenderbuffer(param1:int, param2:GLObject) : void
      {
         GL.context.bindRenderbuffer(param1,param2);
      }
      
      public static function bindSampler(param1:int, param2:GLObject) : void
      {
         GL.context.bindSampler(param1,param2);
      }
      
      public static function bindTexture(param1:int, param2:GLObject) : void
      {
         GL.context.bindTexture(param1,param2);
      }
      
      public static function bindTransformFeedback(param1:int, param2:GLObject) : void
      {
         GL.context.bindTransformFeedback(param1,param2);
      }
      
      public static function bindVertexArray(param1:GLObject) : void
      {
         GL.context.bindVertexArray(param1);
      }
      
      public static function blitFramebuffer(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int) : void
      {
         GL.context.blitFramebuffer(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
      }
      
      public static function blendColor(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         GL.context.blendColor(param1,param2,param3,param4);
      }
      
      public static function blendEquation(param1:int) : void
      {
         GL.context.blendEquation(param1);
      }
      
      public static function blendEquationSeparate(param1:int, param2:int) : void
      {
         GL.context.blendEquationSeparate(param1,param2);
      }
      
      public static function blendFunc(param1:int, param2:int) : void
      {
         GL.context.blendFunc(param1,param2);
      }
      
      public static function blendFuncSeparate(param1:int, param2:int, param3:int, param4:int) : void
      {
         GL.context.blendFuncSeparate(param1,param2,param3,param4);
      }
      
      public static function bufferData(param1:int, param2:int, param3:int, param4:int) : void
      {
         GL.context.bufferData(param1,param2,param3,param4);
      }
      
      public static function bufferSubData(param1:int, param2:int, param3:int, param4:int) : void
      {
         GL.context.bufferSubData(param1,param2,param3,param4);
      }
      
      public static function checkFramebufferStatus(param1:int) : int
      {
         return GL.context.checkFramebufferStatus(param1);
      }
      
      public static function clear(param1:int) : void
      {
         GL.context.clear(param1);
      }
      
      public static function clearBufferfi(param1:int, param2:int, param3:Number, param4:int) : void
      {
         GL.context.clearBufferfi(param1,param2,param3,param4);
      }
      
      public static function clearBufferfv(param1:int, param2:int, param3:int) : void
      {
         GL.context.clearBufferfv(param1,param2,param3);
      }
      
      public static function clearBufferiv(param1:int, param2:int, param3:int) : void
      {
         GL.context.clearBufferiv(param1,param2,param3);
      }
      
      public static function clearBufferuiv(param1:int, param2:int, param3:int) : void
      {
         GL.context.clearBufferuiv(param1,param2,param3);
      }
      
      public static function clearColor(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         GL.context.clearColor(param1,param2,param3,param4);
      }
      
      public static function clearDepthf(param1:Number) : void
      {
         GL.context.clearDepthf(param1);
      }
      
      public static function clearStencil(param1:int) : void
      {
         GL.context.clearStencil(param1);
      }
      
      public static function clientWaitSync(param1:*, param2:int, param3:___Int64) : int
      {
         return GL.context.clientWaitSync(param1,param2,param3);
      }
      
      public static function colorMask(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean) : void
      {
         GL.context.colorMask(param1,param2,param3,param4);
      }
      
      public static function compileShader(param1:GLObject) : void
      {
         GL.context.compileShader(param1);
      }
      
      public static function compressedTexImage2D(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int) : void
      {
         GL.context.compressedTexImage2D(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public static function compressedTexImage3D(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int) : void
      {
         GL.context.compressedTexImage3D(param1,param2,param3,param4,param5,param6,param7,param8,param9);
      }
      
      public static function compressedTexSubImage2D(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int) : void
      {
         GL.context.compressedTexSubImage2D(param1,param2,param3,param4,param5,param6,param7,param8,param9);
      }
      
      public static function compressedTexSubImage3D(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int, param11:int) : void
      {
         GL.context.compressedTexSubImage3D(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
      }
      
      public static function copyBufferSubData(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         GL.context.copyBufferSubData(param1,param2,param3,param4,param5);
      }
      
      public static function copyTexImage2D(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int) : void
      {
         GL.context.copyTexImage2D(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public static function copyTexSubImage2D(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int) : void
      {
         GL.context.copyTexSubImage2D(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public static function copyTexSubImage3D(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int) : void
      {
         GL.context.copyTexSubImage3D(param1,param2,param3,param4,param5,param6,param7,param8,param9);
      }
      
      public static function createBuffer() : GLObject
      {
         return GL.context.createBuffer();
      }
      
      public static function createFramebuffer() : GLObject
      {
         return GL.context.createFramebuffer();
      }
      
      public static function createProgram() : GLObject
      {
         return GL.context.createProgram();
      }
      
      public static function createQuery() : GLObject
      {
         return GL.context.createQuery();
      }
      
      public static function createRenderbuffer() : GLObject
      {
         return GL.context.createRenderbuffer();
      }
      
      public static function createSampler() : GLObject
      {
         return GL.context.createSampler();
      }
      
      public static function createShader(param1:int) : GLObject
      {
         return GL.context.createShader(param1);
      }
      
      public static function createTexture() : GLObject
      {
         return GL.context.createTexture();
      }
      
      public static function createTransformFeedback() : GLObject
      {
         return GL.context.createTransformFeedback();
      }
      
      public static function createVertexArray() : GLObject
      {
         return GL.context.createVertexArray();
      }
      
      public static function cullFace(param1:int) : void
      {
         GL.context.cullFace(param1);
      }
      
      public static function deleteBuffer(param1:GLObject) : void
      {
         GL.context.deleteBuffer(param1);
      }
      
      public static function deleteFramebuffer(param1:GLObject) : void
      {
         GL.context.deleteFramebuffer(param1);
      }
      
      public static function deleteProgram(param1:GLObject) : void
      {
         GL.context.deleteProgram(param1);
      }
      
      public static function deleteQuery(param1:GLObject) : void
      {
         GL.context.deleteQuery(param1);
      }
      
      public static function deleteRenderbuffer(param1:GLObject) : void
      {
         GL.context.deleteRenderbuffer(param1);
      }
      
      public static function deleteSampler(param1:GLObject) : void
      {
         GL.context.deleteSampler(param1);
      }
      
      public static function deleteShader(param1:GLObject) : void
      {
         GL.context.deleteShader(param1);
      }
      
      public static function deleteSync(param1:*) : void
      {
         GL.context.deleteSync(param1);
      }
      
      public static function deleteTexture(param1:GLObject) : void
      {
         GL.context.deleteTexture(param1);
      }
      
      public static function deleteTransformFeedback(param1:GLObject) : void
      {
         GL.context.deleteTransformFeedback(param1);
      }
      
      public static function deleteVertexArray(param1:GLObject) : void
      {
         GL.context.deleteVertexArray(param1);
      }
      
      public static function depthFunc(param1:int) : void
      {
         GL.context.depthFunc(param1);
      }
      
      public static function depthMask(param1:Boolean) : void
      {
         GL.context.depthMask(param1);
      }
      
      public static function depthRangef(param1:Number, param2:Number) : void
      {
         GL.context.depthRangef(param1,param2);
      }
      
      public static function detachShader(param1:GLObject, param2:GLObject) : void
      {
         GL.context.detachShader(param1,param2);
      }
      
      public static function disable(param1:int) : void
      {
         GL.context.disable(param1);
      }
      
      public static function disableVertexAttribArray(param1:int) : void
      {
         GL.context.disableVertexAttribArray(param1);
      }
      
      public static function drawArrays(param1:int, param2:int, param3:int) : void
      {
         GL.context.drawArrays(param1,param2,param3);
      }
      
      public static function drawArraysInstanced(param1:int, param2:int, param3:int, param4:int) : void
      {
         GL.context.drawArraysInstanced(param1,param2,param3,param4);
      }
      
      public static function drawBuffers(param1:Array) : void
      {
         GL.context.drawBuffers(param1);
      }
      
      public static function drawElements(param1:int, param2:int, param3:int, param4:int) : void
      {
         GL.context.drawElements(param1,param2,param3,param4);
      }
      
      public static function drawElementsInstanced(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         GL.context.drawElementsInstanced(param1,param2,param3,param4,param5);
      }
      
      public static function drawRangeElements(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         GL.context.drawRangeElements(param1,param2,param3,param4,param5,param6);
      }
      
      public static function enable(param1:int) : void
      {
         GL.context.enable(param1);
      }
      
      public static function enableVertexAttribArray(param1:int) : void
      {
         GL.context.enableVertexAttribArray(param1);
      }
      
      public static function endQuery(param1:int) : void
      {
         GL.context.endQuery(param1);
      }
      
      public static function endTransformFeedback() : void
      {
         GL.context.endTransformFeedback();
      }
      
      public static function fenceSync(param1:int, param2:int) : *
      {
         return GL.context.fenceSync(param1,param2);
      }
      
      public static function finish() : void
      {
         GL.context.finish();
      }
      
      public static function flush() : void
      {
         GL.context.flush();
      }
      
      public static function framebufferRenderbuffer(param1:int, param2:int, param3:int, param4:GLObject) : void
      {
         GL.context.framebufferRenderbuffer(param1,param2,param3,param4);
      }
      
      public static function framebufferTexture2D(param1:int, param2:int, param3:int, param4:GLObject, param5:int) : void
      {
         GL.context.framebufferTexture2D(param1,param2,param3,param4,param5);
      }
      
      public static function framebufferTextureLayer(param1:int, param2:int, param3:GLObject, param4:int, param5:int) : void
      {
         GL.context.framebufferTextureLayer(param1,param2,param3,param4,param5);
      }
      
      public static function frontFace(param1:int) : void
      {
         GL.context.frontFace(param1);
      }
      
      public static function generateMipmap(param1:int) : void
      {
         GL.context.generateMipmap(param1);
      }
      
      public static function getActiveAttrib(param1:GLObject, param2:int) : Object
      {
         return GL.context.getActiveAttrib(param1,param2);
      }
      
      public static function getActiveUniform(param1:GLObject, param2:int) : Object
      {
         return GL.context.getActiveUniform(param1,param2);
      }
      
      public static function getActiveUniformBlocki(param1:GLObject, param2:int, param3:int) : int
      {
         return GL.context.getActiveUniformBlocki(param1,param2,param3);
      }
      
      public static function getActiveUniformBlockiv(param1:GLObject, param2:int, param3:int, param4:int) : void
      {
         GL.context.getActiveUniformBlockiv(param1,param2,param3,param4);
      }
      
      public static function getActiveUniformBlockName(param1:GLObject, param2:int) : String
      {
         return GL.context.getActiveUniformBlockName(param1,param2);
      }
      
      public static function getActiveUniformBlockParameter(param1:GLObject, param2:int, param3:int) : *
      {
         return GL.context.getActiveUniformBlockParameter(param1,param2,param3);
      }
      
      public static function getActiveUniforms(param1:GLObject, param2:Array, param3:int) : *
      {
         return GL.context.getActiveUniforms(param1,param2,param3);
      }
      
      public static function getActiveUniformsiv(param1:GLObject, param2:Array, param3:int, param4:int) : void
      {
         GL.context.getActiveUniformsiv(param1,param2,param3,param4);
      }
      
      public static function getAttachedShaders(param1:GLObject) : Array
      {
         return GL.context.getAttachedShaders(param1);
      }
      
      public static function getAttribLocation(param1:GLObject, param2:String) : int
      {
         return GL.context.getAttribLocation(param1,param2);
      }
      
      public static function getBoolean(param1:int) : Boolean
      {
         return GL.context.getBoolean(param1);
      }
      
      public static function getBooleanv(param1:int, param2:int) : void
      {
         GL.context.getBooleanv(param1,param2);
      }
      
      public static function getBufferParameter(param1:int, param2:int) : *
      {
         return GL.context.getBufferParameter(param1,param2);
      }
      
      public static function getBufferParameteri(param1:int, param2:int) : int
      {
         return GL.context.getBufferParameteri(param1,param2);
      }
      
      public static function getBufferParameteri64v(param1:int, param2:int, param3:int) : void
      {
         GL.context.getBufferParameteri64v(param1,param2,param3);
      }
      
      public static function getBufferParameteriv(param1:int, param2:int, param3:int) : void
      {
         GL.context.getBufferParameteriv(param1,param2,param3);
      }
      
      public static function getBufferPointerv(param1:int, param2:int) : int
      {
         return GL.context.getBufferPointerv(param1,param2);
      }
      
      public static function getBufferSubData(param1:int, param2:int, param3:int, param4:int) : void
      {
         GL.context.getBufferSubData(param1,param2,param3,param4);
      }
      
      public static function getContextAttributes() : Object
      {
         return GL.context.getContextAttributes();
      }
      
      public static function getError() : int
      {
         return GL.context.getError();
      }
      
      public static function getExtension(param1:String) : *
      {
         return GL.context.getExtension(param1);
      }
      
      public static function getFloat(param1:int) : Number
      {
         return GL.context.getFloat(param1);
      }
      
      public static function getFloatv(param1:int, param2:int) : void
      {
         GL.context.getFloatv(param1,param2);
      }
      
      public static function getFragDataLocation(param1:GLObject, param2:String) : int
      {
         return GL.context.getFragDataLocation(param1,param2);
      }
      
      public static function getFramebufferAttachmentParameter(param1:int, param2:int, param3:int) : *
      {
         return GL.context.getFramebufferAttachmentParameter(param1,param2,param3);
      }
      
      public static function getFramebufferAttachmentParameteri(param1:int, param2:int, param3:int) : int
      {
         return GL.context.getFramebufferAttachmentParameteri(param1,param2,param3);
      }
      
      public static function getFramebufferAttachmentParameteriv(param1:int, param2:int, param3:int, param4:int) : void
      {
         GL.context.getFramebufferAttachmentParameteriv(param1,param2,param3,param4);
      }
      
      public static function getIndexedParameter(param1:int, param2:int) : *
      {
         return GL.context.getIndexedParameter(param1,param2);
      }
      
      public static function getInteger(param1:int) : int
      {
         return GL.context.getInteger(param1);
      }
      
      public static function getInteger64(param1:int) : ___Int64
      {
         return GL.context.getInteger64(param1);
      }
      
      public static function getInteger64i(param1:int) : ___Int64
      {
         return GL.context.getInteger64i(param1);
      }
      
      public static function getInteger64i_v(param1:int, param2:int, param3:int) : void
      {
         GL.context.getInteger64i_v(param1,param2,param3);
      }
      
      public static function getInteger64v(param1:int, param2:int) : void
      {
         GL.context.getInteger64v(param1,param2);
      }
      
      public static function getIntegeri_v(param1:int, param2:int, param3:int) : void
      {
         GL.context.getIntegeri_v(param1,param2,param3);
      }
      
      public static function getIntegerv(param1:int, param2:int) : void
      {
         GL.context.getIntegerv(param1,param2);
      }
      
      public static function getInternalformati(param1:int, param2:int, param3:int) : int
      {
         return GL.context.getInternalformati(param1,param2,param3);
      }
      
      public static function getInternalformativ(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         GL.context.getInternalformativ(param1,param2,param3,param4,param5);
      }
      
      public static function getInternalformatParameter(param1:int, param2:int, param3:int) : *
      {
         return GL.context.getInternalformatParameter(param1,param2,param3);
      }
      
      public static function getParameter(param1:int) : *
      {
         return GL.context.getParameter(param1);
      }
      
      public static function getProgrami(param1:GLObject, param2:int) : int
      {
         return GL.context.getProgrami(param1,param2);
      }
      
      public static function getProgramiv(param1:GLObject, param2:int, param3:int) : void
      {
         GL.context.getProgramiv(param1,param2,param3);
      }
      
      public static function getProgramBinary(param1:GLObject, param2:int) : Bytes
      {
         return GL.context.getProgramBinary(param1,param2);
      }
      
      public static function getProgramInfoLog(param1:GLObject) : String
      {
         return GL.context.getProgramInfoLog(param1);
      }
      
      public static function getProgramParameter(param1:GLObject, param2:int) : *
      {
         return GL.context.getProgramParameter(param1,param2);
      }
      
      public static function getQuery(param1:int, param2:int) : GLObject
      {
         return GL.context.getQuery(param1,param2);
      }
      
      public static function getQueryi(param1:int, param2:int) : int
      {
         return GL.context.getQueryi(param1,param2);
      }
      
      public static function getQueryiv(param1:int, param2:int, param3:int) : void
      {
         GL.context.getQueryiv(param1,param2,param3);
      }
      
      public static function getQueryObjectui(param1:GLObject, param2:int) : int
      {
         return GL.context.getQueryObjectui(param1,param2);
      }
      
      public static function getQueryObjectuiv(param1:GLObject, param2:int, param3:int) : void
      {
         GL.context.getQueryObjectuiv(param1,param2,param3);
      }
      
      public static function getQueryParameter(param1:GLObject, param2:int) : *
      {
         return GL.context.getQueryParameter(param1,param2);
      }
      
      public static function getRenderbufferParameter(param1:int, param2:int) : *
      {
         return GL.context.getRenderbufferParameter(param1,param2);
      }
      
      public static function getRenderbufferParameteri(param1:int, param2:int) : int
      {
         return GL.context.getRenderbufferParameteri(param1,param2);
      }
      
      public static function getRenderbufferParameteriv(param1:int, param2:int, param3:int) : void
      {
         GL.context.getRenderbufferParameteriv(param1,param2,param3);
      }
      
      public static function getSamplerParameter(param1:GLObject, param2:int) : *
      {
         return GL.context.getSamplerParameter(param1,param2);
      }
      
      public static function getSamplerParameterf(param1:GLObject, param2:int) : Number
      {
         return GL.context.getSamplerParameterf(param1,param2);
      }
      
      public static function getSamplerParameterfv(param1:GLObject, param2:int, param3:int) : void
      {
         GL.context.getSamplerParameterfv(param1,param2,param3);
      }
      
      public static function getSamplerParameteri(param1:GLObject, param2:int) : int
      {
         return GL.context.getSamplerParameteri(param1,param2);
      }
      
      public static function getSamplerParameteriv(param1:GLObject, param2:int, param3:int) : void
      {
         GL.context.getSamplerParameteriv(param1,param2,param3);
      }
      
      public static function getShaderi(param1:GLObject, param2:int) : int
      {
         return GL.context.getShaderi(param1,param2);
      }
      
      public static function getShaderiv(param1:GLObject, param2:int, param3:int) : void
      {
         GL.context.getShaderiv(param1,param2,param3);
      }
      
      public static function getShaderInfoLog(param1:GLObject) : String
      {
         return GL.context.getShaderInfoLog(param1);
      }
      
      public static function getShaderParameter(param1:GLObject, param2:int) : *
      {
         return GL.context.getShaderParameter(param1,param2);
      }
      
      public static function getShaderPrecisionFormat(param1:int, param2:int) : Object
      {
         return GL.context.getShaderPrecisionFormat(param1,param2);
      }
      
      public static function getShaderSource(param1:GLObject) : String
      {
         return GL.context.getShaderSource(param1);
      }
      
      public static function getString(param1:int) : String
      {
         return GL.context.getString(param1);
      }
      
      public static function getStringi(param1:int, param2:int) : String
      {
         return GL.context.getStringi(param1,param2);
      }
      
      public static function getSupportedExtensions() : Array
      {
         return GL.context.getSupportedExtensions();
      }
      
      public static function getSyncParameter(param1:*, param2:int) : *
      {
         return GL.context.getSyncParameter(param1,param2);
      }
      
      public static function getSyncParameteri(param1:*, param2:int) : int
      {
         return GL.context.getSyncParameteri(param1,param2);
      }
      
      public static function getSyncParameteriv(param1:*, param2:int, param3:int) : void
      {
         GL.context.getSyncParameteriv(param1,param2,param3);
      }
      
      public static function getTexParameter(param1:int, param2:int) : *
      {
         return GL.context.getTexParameter(param1,param2);
      }
      
      public static function getTexParameterf(param1:int, param2:int) : Number
      {
         return GL.context.getTexParameterf(param1,param2);
      }
      
      public static function getTexParameterfv(param1:int, param2:int, param3:int) : void
      {
         GL.context.getTexParameterfv(param1,param2,param3);
      }
      
      public static function getTexParameteri(param1:int, param2:int) : int
      {
         return GL.context.getTexParameteri(param1,param2);
      }
      
      public static function getTexParameteriv(param1:int, param2:int, param3:int) : void
      {
         GL.context.getTexParameteriv(param1,param2,param3);
      }
      
      public static function getTransformFeedbackVarying(param1:GLObject, param2:int) : Object
      {
         return GL.context.getTransformFeedbackVarying(param1,param2);
      }
      
      public static function getUniform(param1:GLObject, param2:int) : *
      {
         return GL.context.getUniform(param1,param2);
      }
      
      public static function getUniformf(param1:GLObject, param2:int) : Number
      {
         return GL.context.getUniformf(param1,param2);
      }
      
      public static function getUniformfv(param1:GLObject, param2:int, param3:int) : void
      {
         GL.context.getUniformfv(param1,param2,param3);
      }
      
      public static function getUniformi(param1:GLObject, param2:int) : int
      {
         return GL.context.getUniformi(param1,param2);
      }
      
      public static function getUniformiv(param1:GLObject, param2:int, param3:int) : void
      {
         GL.context.getUniformiv(param1,param2,param3);
      }
      
      public static function getUniformui(param1:GLObject, param2:int) : int
      {
         return GL.context.getUniformui(param1,param2);
      }
      
      public static function getUniformuiv(param1:GLObject, param2:int, param3:int) : void
      {
         GL.context.getUniformuiv(param1,param2,param3);
      }
      
      public static function getUniformBlockIndex(param1:GLObject, param2:String) : int
      {
         return GL.context.getUniformBlockIndex(param1,param2);
      }
      
      public static function getUniformIndices(param1:GLObject, param2:Array) : Array
      {
         return GL.context.getUniformIndices(param1,param2);
      }
      
      public static function getUniformLocation(param1:GLObject, param2:String) : int
      {
         return GL.context.getUniformLocation(param1,param2);
      }
      
      public static function getVertexAttrib(param1:int, param2:int) : *
      {
         return GL.context.getVertexAttrib(param1,param2);
      }
      
      public static function getVertexAttribf(param1:int, param2:int) : Number
      {
         return GL.context.getVertexAttribf(param1,param2);
      }
      
      public static function getVertexAttribfv(param1:int, param2:int, param3:int) : void
      {
         GL.context.getVertexAttribfv(param1,param2,param3);
      }
      
      public static function getVertexAttribi(param1:int, param2:int) : int
      {
         return GL.context.getVertexAttribi(param1,param2);
      }
      
      public static function getVertexAttribIi(param1:int, param2:int) : int
      {
         return GL.context.getVertexAttribIi(param1,param2);
      }
      
      public static function getVertexAttribIiv(param1:int, param2:int, param3:int) : void
      {
         GL.context.getVertexAttribIiv(param1,param2,param3);
      }
      
      public static function getVertexAttribIui(param1:int, param2:int) : int
      {
         return GL.context.getVertexAttribIui(param1,param2);
      }
      
      public static function getVertexAttribIuiv(param1:int, param2:int, param3:int) : void
      {
         GL.context.getVertexAttribIuiv(param1,param2,param3);
      }
      
      public static function getVertexAttribiv(param1:int, param2:int, param3:int) : void
      {
         GL.context.getVertexAttribiv(param1,param2,param3);
      }
      
      public static function getVertexAttribPointerv(param1:int, param2:int) : int
      {
         return GL.context.getVertexAttribPointerv(param1,param2);
      }
      
      public static function hint(param1:int, param2:int) : void
      {
         GL.context.hint(param1,param2);
      }
      
      public static function invalidateFramebuffer(param1:int, param2:Array) : void
      {
         GL.context.invalidateFramebuffer(param1,param2);
      }
      
      public static function invalidateSubFramebuffer(param1:int, param2:Array, param3:int, param4:int, param5:int, param6:int) : void
      {
         GL.context.invalidateSubFramebuffer(param1,param2,param3,param4,param5,param6);
      }
      
      public static function isBuffer(param1:GLObject) : Boolean
      {
         return GL.context.isBuffer(param1);
      }
      
      public static function isContextLost() : Boolean
      {
         return GL.context.isContextLost();
      }
      
      public static function isEnabled(param1:int) : Boolean
      {
         return GL.context.isEnabled(param1);
      }
      
      public static function isFramebuffer(param1:GLObject) : Boolean
      {
         return GL.context.isFramebuffer(param1);
      }
      
      public static function isProgram(param1:GLObject) : Boolean
      {
         return GL.context.isProgram(param1);
      }
      
      public static function isQuery(param1:GLObject) : Boolean
      {
         return GL.context.isQuery(param1);
      }
      
      public static function isRenderbuffer(param1:GLObject) : Boolean
      {
         return GL.context.isRenderbuffer(param1);
      }
      
      public static function isSampler(param1:GLObject) : Boolean
      {
         return GL.context.isSampler(param1);
      }
      
      public static function isShader(param1:GLObject) : Boolean
      {
         return GL.context.isShader(param1);
      }
      
      public static function isSync(param1:*) : Boolean
      {
         return GL.context.isSync(param1);
      }
      
      public static function isTexture(param1:GLObject) : Boolean
      {
         return GL.context.isTexture(param1);
      }
      
      public static function isTransformFeedback(param1:GLObject) : Boolean
      {
         return GL.context.isTransformFeedback(param1);
      }
      
      public static function isVertexArray(param1:GLObject) : Boolean
      {
         return GL.context.isVertexArray(param1);
      }
      
      public static function lineWidth(param1:Number) : void
      {
         GL.context.lineWidth(param1);
      }
      
      public static function linkProgram(param1:GLObject) : void
      {
         GL.context.linkProgram(param1);
      }
      
      public static function mapBufferRange(param1:int, param2:int, param3:int, param4:int) : int
      {
         return GL.context.mapBufferRange(param1,param2,param3,param4);
      }
      
      public static function pauseTransformFeedback() : void
      {
         GL.context.pauseTransformFeedback();
      }
      
      public static function pixelStorei(param1:int, param2:int) : void
      {
         GL.context.pixelStorei(param1,param2);
      }
      
      public static function polygonOffset(param1:Number, param2:Number) : void
      {
         GL.context.polygonOffset(param1,param2);
      }
      
      public static function programBinary(param1:GLObject, param2:int, param3:int, param4:int) : void
      {
         GL.context.programBinary(param1,param2,param3,param4);
      }
      
      public static function programParameteri(param1:GLObject, param2:int, param3:int) : void
      {
         GL.context.programParameteri(param1,param2,param3);
      }
      
      public static function readBuffer(param1:int) : void
      {
         GL.context.readBuffer(param1);
      }
      
      public static function readPixels(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:BytePointerData) : void
      {
         GL.context.readPixels(param1,param2,param3,param4,param5,param6,param7);
      }
      
      public static function releaseShaderCompiler() : void
      {
         GL.context.releaseShaderCompiler();
      }
      
      public static function renderbufferStorage(param1:int, param2:int, param3:int, param4:int) : void
      {
         GL.context.renderbufferStorage(param1,param2,param3,param4);
      }
      
      public static function renderbufferStorageMultisample(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         GL.context.renderbufferStorageMultisample(param1,param2,param3,param4,param5);
      }
      
      public static function resumeTransformFeedback() : void
      {
         GL.context.resumeTransformFeedback();
      }
      
      public static function sampleCoverage(param1:Number, param2:Boolean) : void
      {
         GL.context.sampleCoverage(param1,param2);
      }
      
      public static function samplerParameterf(param1:GLObject, param2:int, param3:Number) : void
      {
         GL.context.samplerParameterf(param1,param2,param3);
      }
      
      public static function samplerParameteri(param1:GLObject, param2:int, param3:int) : void
      {
         GL.context.samplerParameteri(param1,param2,param3);
      }
      
      public static function scissor(param1:int, param2:int, param3:int, param4:int) : void
      {
         GL.context.scissor(param1,param2,param3,param4);
      }
      
      public static function shaderBinary(param1:Array, param2:int, param3:int, param4:int) : void
      {
         GL.context.shaderBinary(param1,param2,param3,param4);
      }
      
      public static function shaderSource(param1:GLObject, param2:String) : void
      {
         GL.context.shaderSource(param1,param2);
      }
      
      public static function stencilFunc(param1:int, param2:int, param3:int) : void
      {
         GL.context.stencilFunc(param1,param2,param3);
      }
      
      public static function stencilFuncSeparate(param1:int, param2:int, param3:int, param4:int) : void
      {
         GL.context.stencilFuncSeparate(param1,param2,param3,param4);
      }
      
      public static function stencilMask(param1:int) : void
      {
         GL.context.stencilMask(param1);
      }
      
      public static function stencilMaskSeparate(param1:int, param2:int) : void
      {
         GL.context.stencilMaskSeparate(param1,param2);
      }
      
      public static function stencilOp(param1:int, param2:int, param3:int) : void
      {
         GL.context.stencilOp(param1,param2,param3);
      }
      
      public static function stencilOpSeparate(param1:int, param2:int, param3:int, param4:int) : void
      {
         GL.context.stencilOpSeparate(param1,param2,param3,param4);
      }
      
      public static function texImage2D(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int) : void
      {
         GL.context.texImage2D(param1,param2,param3,param4,param5,param6,param7,param8,param9);
      }
      
      public static function texImage3D(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int) : void
      {
         GL.context.texImage3D(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
      }
      
      public static function texStorage2D(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         GL.context.texStorage2D(param1,param2,param3,param4,param5);
      }
      
      public static function texStorage3D(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         GL.context.texStorage3D(param1,param2,param3,param4,param5,param6);
      }
      
      public static function texParameterf(param1:int, param2:int, param3:Number) : void
      {
         GL.context.texParameterf(param1,param2,param3);
      }
      
      public static function texParameteri(param1:int, param2:int, param3:int) : void
      {
         GL.context.texParameteri(param1,param2,param3);
      }
      
      public static function texSubImage2D(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:ArrayBufferView) : void
      {
         GL.context.texSubImage2D(param1,param2,param3,param4,param5,param6,param7,param8,param9);
      }
      
      public static function texSubImage3D(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int, param11:int) : void
      {
         GL.context.texSubImage3D(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
      }
      
      public static function transformFeedbackVaryings(param1:GLObject, param2:Array, param3:int) : void
      {
         GL.context.transformFeedbackVaryings(param1,param2,param3);
      }
      
      public static function uniform1f(param1:int, param2:Number) : void
      {
         GL.context.uniform1f(param1,param2);
      }
      
      public static function uniform1fv(param1:int, param2:int, param3:int) : void
      {
         GL.context.uniform1fv(param1,param2,param3);
      }
      
      public static function uniform1i(param1:int, param2:int) : void
      {
         GL.context.uniform1i(param1,param2);
      }
      
      public static function uniform1iv(param1:int, param2:int, param3:int) : void
      {
         GL.context.uniform1iv(param1,param2,param3);
      }
      
      public static function uniform1ui(param1:int, param2:int) : void
      {
         GL.context.uniform1ui(param1,param2);
      }
      
      public static function uniform1uiv(param1:int, param2:int, param3:int) : void
      {
         GL.context.uniform1uiv(param1,param2,param3);
      }
      
      public static function uniform2f(param1:int, param2:Number, param3:Number) : void
      {
         GL.context.uniform2f(param1,param2,param3);
      }
      
      public static function uniform2fv(param1:int, param2:int, param3:int) : void
      {
         GL.context.uniform2fv(param1,param2,param3);
      }
      
      public static function uniform2i(param1:int, param2:int, param3:int) : void
      {
         GL.context.uniform2i(param1,param2,param3);
      }
      
      public static function uniform2iv(param1:int, param2:int, param3:int) : void
      {
         GL.context.uniform2iv(param1,param2,param3);
      }
      
      public static function uniform2ui(param1:int, param2:int, param3:int) : void
      {
         GL.context.uniform2ui(param1,param2,param3);
      }
      
      public static function uniform2uiv(param1:int, param2:int, param3:int) : void
      {
         GL.context.uniform2uiv(param1,param2,param3);
      }
      
      public static function uniform3f(param1:int, param2:Number, param3:Number, param4:Number) : void
      {
         GL.context.uniform3f(param1,param2,param3,param4);
      }
      
      public static function uniform3fv(param1:int, param2:int, param3:int) : void
      {
         GL.context.uniform3fv(param1,param2,param3);
      }
      
      public static function uniform3i(param1:int, param2:int, param3:int, param4:int) : void
      {
         GL.context.uniform3i(param1,param2,param3,param4);
      }
      
      public static function uniform3iv(param1:int, param2:int, param3:int) : void
      {
         GL.context.uniform3iv(param1,param2,param3);
      }
      
      public static function uniform3ui(param1:int, param2:int, param3:int, param4:int) : void
      {
         GL.context.uniform3ui(param1,param2,param3,param4);
      }
      
      public static function uniform3uiv(param1:int, param2:int, param3:int) : void
      {
         GL.context.uniform3uiv(param1,param2,param3);
      }
      
      public static function uniform4f(param1:int, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         GL.context.uniform4f(param1,param2,param3,param4,param5);
      }
      
      public static function uniform4fv(param1:int, param2:int, param3:int) : void
      {
         GL.context.uniform4fv(param1,param2,param3);
      }
      
      public static function uniform4i(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         GL.context.uniform4i(param1,param2,param3,param4,param5);
      }
      
      public static function uniform4iv(param1:int, param2:int, param3:int) : void
      {
         GL.context.uniform4iv(param1,param2,param3);
      }
      
      public static function uniform4ui(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         GL.context.uniform4ui(param1,param2,param3,param4,param5);
      }
      
      public static function uniform4uiv(param1:int, param2:int, param3:int) : void
      {
         GL.context.uniform4uiv(param1,param2,param3);
      }
      
      public static function uniformBlockBinding(param1:GLObject, param2:int, param3:int) : void
      {
         GL.context.uniformBlockBinding(param1,param2,param3);
      }
      
      public static function uniformMatrix2fv(param1:int, param2:int, param3:Boolean, param4:int) : void
      {
         GL.context.uniformMatrix2fv(param1,param2,param3,param4);
      }
      
      public static function uniformMatrix2x3fv(param1:int, param2:int, param3:Boolean, param4:int) : void
      {
         GL.context.uniformMatrix2x3fv(param1,param2,param3,param4);
      }
      
      public static function uniformMatrix2x4fv(param1:int, param2:int, param3:Boolean, param4:int) : void
      {
         GL.context.uniformMatrix2x4fv(param1,param2,param3,param4);
      }
      
      public static function uniformMatrix3fv(param1:int, param2:int, param3:Boolean, param4:int) : void
      {
         GL.context.uniformMatrix3fv(param1,param2,param3,param4);
      }
      
      public static function uniformMatrix3x2fv(param1:int, param2:int, param3:Boolean, param4:int) : void
      {
         GL.context.uniformMatrix3x2fv(param1,param2,param3,param4);
      }
      
      public static function uniformMatrix3x4fv(param1:int, param2:int, param3:Boolean, param4:int) : void
      {
         GL.context.uniformMatrix3x4fv(param1,param2,param3,param4);
      }
      
      public static function uniformMatrix4fv(param1:int, param2:int, param3:Boolean, param4:int) : void
      {
         GL.context.uniformMatrix4fv(param1,param2,param3,param4);
      }
      
      public static function uniformMatrix4x2fv(param1:int, param2:int, param3:Boolean, param4:int) : void
      {
         GL.context.uniformMatrix4x2fv(param1,param2,param3,param4);
      }
      
      public static function uniformMatrix4x3fv(param1:int, param2:int, param3:Boolean, param4:int) : void
      {
         GL.context.uniformMatrix4x3fv(param1,param2,param3,param4);
      }
      
      public static function unmapBuffer(param1:int) : Boolean
      {
         return GL.context.unmapBuffer(param1);
      }
      
      public static function useProgram(param1:GLObject) : void
      {
         GL.context.useProgram(param1);
      }
      
      public static function validateProgram(param1:GLObject) : void
      {
         GL.context.validateProgram(param1);
      }
      
      public static function vertexAttrib1f(param1:int, param2:Number) : void
      {
         GL.context.vertexAttrib1f(param1,param2);
      }
      
      public static function vertexAttrib1fv(param1:int, param2:int) : void
      {
         GL.context.vertexAttrib1fv(param1,param2);
      }
      
      public static function vertexAttrib2f(param1:int, param2:Number, param3:Number) : void
      {
         GL.context.vertexAttrib2f(param1,param2,param3);
      }
      
      public static function vertexAttrib2fv(param1:int, param2:int) : void
      {
         GL.context.vertexAttrib2fv(param1,param2);
      }
      
      public static function vertexAttrib3f(param1:int, param2:Number, param3:Number, param4:Number) : void
      {
         GL.context.vertexAttrib3f(param1,param2,param3,param4);
      }
      
      public static function vertexAttrib3fv(param1:int, param2:int) : void
      {
         GL.context.vertexAttrib3fv(param1,param2);
      }
      
      public static function vertexAttrib4f(param1:int, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         GL.context.vertexAttrib4f(param1,param2,param3,param4,param5);
      }
      
      public static function vertexAttrib4fv(param1:int, param2:int) : void
      {
         GL.context.vertexAttrib4fv(param1,param2);
      }
      
      public static function vertexAttribDivisor(param1:int, param2:int) : void
      {
         GL.context.vertexAttribDivisor(param1,param2);
      }
      
      public static function vertexAttribI4i(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         GL.context.vertexAttribI4i(param1,param2,param3,param4,param5);
      }
      
      public static function vertexAttribI4iv(param1:int, param2:int) : void
      {
         GL.context.vertexAttribI4iv(param1,param2);
      }
      
      public static function vertexAttribI4ui(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         GL.context.vertexAttribI4ui(param1,param2,param3,param4,param5);
      }
      
      public static function vertexAttribI4uiv(param1:int, param2:int) : void
      {
         GL.context.vertexAttribI4uiv(param1,param2);
      }
      
      public static function vertexAttribIPointer(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         GL.context.vertexAttribIPointer(param1,param2,param3,param4,param5);
      }
      
      public static function vertexAttribPointer(param1:int, param2:int, param3:int, param4:Boolean, param5:int, param6:int) : void
      {
         GL.context.vertexAttribPointer(param1,param2,param3,param4,param5,param6);
      }
      
      public static function viewport(param1:int, param2:int, param3:int, param4:int) : void
      {
         GL.context.viewport(param1,param2,param3,param4);
      }
      
      public static function waitSync(param1:*, param2:int, param3:___Int64) : void
      {
         GL.context.waitSync(param1,param2,param3);
      }
      
      public static function __getObjectID(param1:GLObject) : int
      {
         if(param1 == null)
         {
            return 0;
         }
         return param1.id;
      }
   }
}
