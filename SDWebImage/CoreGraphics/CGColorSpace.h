typedef struct CF_BRIDGED_TYPE(id) CGColorSpace *CGColorSpaceRef;




/* Create a DeviceRGB color space. */
//  设备支持的颜色空间
CG_EXTERN CGColorSpaceRef cg_nullable CGColorSpaceCreateDeviceRGB(void)
  CG_AVAILABLE_STARTING(10.0, 2.0);