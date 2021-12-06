
API_AVAILABLE(macos(10.14), ios(12.0), watchos(5.0), tvos(12.0))
NW_RETURNS_RETAINED nw_path_monitor_t nw_path_monitor_create(void);
// 创建一个默认的monitor ， 

//  通过接口类型来创建对象，（只是监控这个网络接口的累心）
API_AVAILABLE(macos(10.14), ios(12.0), watchos(5.0), tvos(12.0))
NW_RETURNS_RETAINED nw_path_monitor_t nw_path_monitor_create_with_type(nw_interface_type_t required_interface_type);

//  禁止哪些网络类型的接口。
API_AVAILABLE(macos(11.0), ios(14.0), watchos(7.0), tvos(14.0))
void
nw_path_monitor_prohibit_interface_type(nw_path_monitor_t monitor,
										nw_interface_type_t interface_type);

#ifdef __BLOCKS__

//  取消的block操作
typedef void (^nw_path_monitor_cancel_handler_t)(void);

//  设置取消的处理回调
API_AVAILABLE(macos(10.14), ios(12.0), watchos(5.0), tvos(12.0))
void
nw_path_monitor_set_cancel_handler(nw_path_monitor_t monitor,
								   nw_path_monitor_cancel_handler_t cancel_handler);

//  更新的回调， 更新的处理block
typedef void (^nw_path_monitor_update_handler_t) (nw_path_t path);

//  设置更新的处理
API_AVAILABLE(macos(10.14), ios(12.0), watchos(5.0), tvos(12.0))
void
nw_path_monitor_set_update_handler(nw_path_monitor_t monitor,
								   nw_path_monitor_update_handler_t update_handler);

#endif // __BLOCKS__

// 设置队列的控制， 在哪个队列上监听这个内容
API_AVAILABLE(macos(10.14), ios(12.0), watchos(5.0), tvos(12.0))
void nw_path_monitor_set_queue(nw_path_monitor_t monitor,
						  dispatch_queue_t queue);

//  开始监听
API_AVAILABLE(macos(10.14), ios(12.0), watchos(5.0), tvos(12.0))
void
nw_path_monitor_start(nw_path_monitor_t monitor);


//  取消监听
API_AVAILABLE(macos(10.14), ios(12.0), watchos(5.0), tvos(12.0))
void
nw_path_monitor_cancel(nw_path_monitor_t monitor);

NW_ASSUME_NONNULL_END

__END_DECLS

#endif /* defined(__NW_PATH_MONITOR_H__) */


