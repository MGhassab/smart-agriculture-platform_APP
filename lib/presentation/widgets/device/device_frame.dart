import 'dart:async';

import 'package:baghyar/data/models/device.dart';
import 'package:baghyar/data/models/loading_indicator.dart';
import 'package:baghyar/presentation/animations/circle.dart';
import 'package:baghyar/presentation/widgets/device/device_antenna.dart';
import 'package:baghyar/presentation/widgets/device/empty_process_button.dart';
import 'package:baghyar/strings.dart';
import 'package:baghyar/styles.dart';
import 'package:flutter/material.dart';

bool isWaiting(bool onInDevice, bool function, bool reached) {
  //if ((onInDevice ^ function) & reached) print('is Waiting');
  return (onInDevice ^ function) & reached;
}

bool processButtonColor(bool onInDevice, bool function, bool reached) {
  if ((onInDevice ^ function) & reached) {
    return function;
  } //isProcessing = onInDevice ^ function
  return onInDevice;
}

class DeviceFrame extends StatefulWidget {
  final Device device;

  const DeviceFrame({Key? key, required this.device}) : super(key: key);

  @override
  _DeviceFrameState createState() => _DeviceFrameState();
}

class _DeviceFrameState extends State<DeviceFrame> {
  //int counter = 0;
  bool notReachable = false;
  bool ongoing = false;
  List<bool> buttonOngoing = [false, false, false];
  List<bool> buttonActive = [false, false, false];
  double neededHeight = 20;
  late Device device;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  initState() {
    if (mounted) super.initState();
    device = widget.device;
    refreshFrame();
  }

  @override
  void dispose() {
    for (LoadingIndicator e in device.buttonLoading) {
      e.refresh();
      e.isCancelled = false;
      e.isStarted = false;
    }
    super.dispose();
  }

  void refreshFrame() {
    Timer.periodic(
      const Duration(milliseconds: 100),
          (Timer timer) =>
          setStateIfMounted(
                () {},
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (device.isLoaded) {
      neededHeight = 0;
      for (int i = 0; i < device.buttonLoading.length; i++) {
        if (isWaiting(
            device.model.customerProcessButtons[i].onInDevice,
            device.model.customerProcessButtons[i].function,
            device.model.customerProcessButtons[i].reachedTimeToAction) &&
            !device.buttonLoading[i].isNotProcessing) {
          // GITHUB print('stop in 78');
          setStateIfMounted(() {
            device.buttonLoading[i].refresh();
          });
        }
        if (device.model.customerProcessButtons[i].isProcessing &&
            device.buttonLoading[i].isNotProcessing) {
          //print(
          //device.model.customerProcessButtons[i].isProcessing.toString() + device.model.customerProcessButtons[i].reachedTimeToAction.toString());
          if (!device.model.customerProcessButtons[i].reachedTimeToAction) {
            // GITHUB print('start in 90');
            //if (device.buttonLoading[i].duration > 1) {
            setStateIfMounted(() {
              device.buttonLoading[i].start(
                  device.model.nextDeviceUpdate,
                  device.model.timeToAction,
                  true,
                  !device.model.customerProcessButtons[i].onInDevice); //TODO
              device.buttonLoading[i].startTimer();
            });

            //}
          }
        }
        if (device.buttonLoading[i].isStarted &&
            device.buttonLoading[i].isNotProcessing) {
          // GITHUB print('start in 100');
          device.buttonLoading[i].isStarted = false;
          //if (device.buttonLoading[i].duration > 1) {
          setStateIfMounted(() {
            device.buttonLoading[i].start(
                device.model.nextDeviceUpdate,
                device.model.timeToAction,
                true,
                !device.model.customerProcessButtons[i].onInDevice); //TODO
            device.buttonLoading[i].startTimer();
          });
        }
        if (!device.model.customerProcessButtons[i].isProcessing &&
            !device.buttonLoading[i].isNotProcessing) {
          // GITHUB print('stop in 93');
          setStateIfMounted(() {
            device.buttonLoading[i].refresh();
          });
        }
      }
      if (device.model.networkCoverage == 0) {
        notReachable = true;
        neededHeight += 20;
      } else {
        if (device.model.customerProcessButtons[0].onInDevice) {
          buttonActive[0] = true;
          neededHeight += 20;
        } else {
          buttonActive[0] = false;
        }
        if (device.model.customerProcessButtons[1].onInDevice) {
          buttonActive[1] = true;
          neededHeight += 20;
        } else {
          buttonActive[1] = false;
        }
        if (buttonActive[0] && buttonActive[1]) neededHeight -= 20;
        notReachable = false;
      }
      if (!device.buttonLoading[0].isNotProcessing ||
          device.model.customerProcessButtons[0].isProcessing ||
          device.buttonLoading[0].isStarted) {
        buttonOngoing[0] = true;
        neededHeight += 20;
      } else {
        buttonOngoing[0] = false;
      }
      if (!device.buttonLoading[1].isNotProcessing ||
          device.model.customerProcessButtons[1].isProcessing ||
          device.buttonLoading[1].isStarted) {
        buttonOngoing[1] = true;
        neededHeight += 20;
      } else {
        buttonOngoing[1] = false;
      }
    }
    //counter++;
    //print('id: '+widget.device.userDevice.id.toString()+' state: '+counter.toString());

    return Container(
      //padding: EdgeInsets.only(bottom: neededHeight),
      margin: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 45 - neededHeight * (3 / 4),
          top: 15 - neededHeight / 4),

      child: Container(
        //width: double.infinity,
        padding: const EdgeInsets.only(top: 5, right: 5, left: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(18),
          ),
          border: Border.all(color: const Color(0x28979797), width: 1),
          color: (Theme
              .of(context)
              .brightness == Brightness.dark)
              ? Colors.black12
              : const Color(0xfff7f7f7),
        ),
        child: Column(
          children: <Widget>[
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10.0),
                if (device.initialized)
                  Text(
                    device.userDevice.name,
                    style: Theme
                        .of(context)
                        .textTheme
                        .overline,
                    textAlign: TextAlign.center,
                  ),
                const Spacer(),
                (device.isLoaded)
                    ? Antenna(networkCoverage: device.model.networkCoverage)
                    : const Antenna(networkCoverage: 0),
                const SizedBox(width: 10.0),
              ],
            ),
            const SizedBox(height: 2.0),
            Container(
              width: 303,
              height: 170,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: (Theme
                      .of(context)
                      .brightness == Brightness.dark)
                      ? const AssetImage('images/dark_shape.png')
                      : const AssetImage('images/combined_shape.png'),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (device.userDevice.typeNumber == 4)
                    (device.isLoaded)
                        ? Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 60,
                            width: 60,
                            child: CircularProgressIndicator(
                              strokeWidth: 10,
                              //backgroundColor: Theme.of(context).accentColor,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                (device.model.customerProcessButtons[2]
                                    .onInDevice)
                                    ? Styles.errorColor
                                    : Theme
                                    .of(context)
                                    .primaryColor,
                              ),
                              value: (device.buttonLoading[2].isCancelled)
                                  ? 0
                                  : ((device.buttonLoading[2].isStarted)
                                  ? 0.01
                                  : device.buttonLoading[2].progress),
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (device
                                    .buttonLoading[2].isNotProcessing) {
                                  if (device
                                      .model
                                      .customerProcessButtons[2]
                                      .isProcessing) {
                                    device.buttonLoading[2].condition =
                                        device
                                            .model
                                            .customerProcessButtons[2]
                                            .onInDevice;
                                  } else {
                                    device.buttonLoading[2].condition =
                                    !device
                                        .model
                                        .customerProcessButtons[2]
                                        .onInDevice;
                                  }
                                  final bool shouldStartTimer = !device
                                      .model
                                      .customerProcessButtons[2]
                                      .isProcessing;
                                  if (shouldStartTimer) {
                                    try {
                                      setStateIfMounted(() {
                                        device.buttonLoading[2]
                                            .toggle(true);
                                      });
                                      await device.callProcess(
                                          3,
                                          device.buttonLoading[2]
                                              .condition);
                                      // GITHUB print('in 211, ');
                                    } catch (e) {
                                      setStateIfMounted(() {
                                        device.buttonLoading[2]
                                            .isStarted = false;
                                      });
                                      // GITHUB print(e);
                                    }
                                  }
                                } else {
                                  device.buttonLoading[2].condition =
                                  !device.buttonLoading[2].condition;
                                  // GITHUB print('236');
                                  try {
                                    setStateIfMounted(() {
                                      device.buttonLoading[2]
                                          .toggle(false);
                                    });
                                    await device.callProcess(
                                        3,
                                        device
                                            .buttonLoading[2].condition);
                                    // GITHUB print('243, isCancelled: ' +
                                    //    device
                                    //        .buttonLoading[2].isCancelled
                                    //        .toString() +
                                    //    ', isStarted: ' +
                                    //    device.buttonLoading[2].isStarted
                                    //        .toString() +
                                    //    ', progress: ' +
                                    //    device.buttonLoading[2].progress
                                    //        .toString());
                                    //device.buttonLoading[1].refresh();
                                  } catch (e) {
                                    setStateIfMounted(() {
                                      device.buttonLoading[2]
                                          .isCancelled = false;
                                      device.buttonLoading[2].condition =
                                      !device
                                          .buttonLoading[2].condition;
                                    });
                                    // GITHUB print(e);
                                  }
                                }
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    const CircleBorder()),
                                //padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                                backgroundColor: MaterialStateProperty
                                    .all((processButtonColor(
                                    device
                                        .model
                                        .customerProcessButtons[2]
                                        .onInDevice,
                                    device
                                        .model
                                        .customerProcessButtons[2]
                                        .function,
                                    device
                                        .model
                                        .customerProcessButtons[2]
                                        .reachedTimeToAction))
                                    ? ((Theme
                                    .of(context)
                                    .brightness ==
                                    Brightness.light)
                                    ? Styles.primaryColorLight
                                    : Styles.primaryColorDark)
                                    : ((Theme
                                    .of(context)
                                    .brightness ==
                                    Brightness.light)
                                    ? Styles
                                    .processButtonColorLight
                                    : Styles
                                    .processButtonColorDark)),
                                overlayColor: MaterialStateProperty
                                    .resolveWith<Color?>(
                                      (states) {
                                    if (states.contains(
                                        MaterialState.pressed)) {
                                      if (device
                                          .model
                                          .customerProcessButtons[2]
                                          .isProcessing) {
                                        return Styles.errorColor;
                                      }
                                      if (device
                                          .model
                                          .customerProcessButtons[2]
                                          .function) {
                                        return const Color.fromRGBO(
                                            187, 187, 187, 1);
                                      }
                                      return Theme
                                          .of(context)
                                          .primaryColor;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              child: (isWaiting(
                                  device
                                      .model
                                      .customerProcessButtons[2]
                                      .onInDevice,
                                  device
                                      .model
                                      .customerProcessButtons[2]
                                      .function,
                                  device
                                      .model
                                      .customerProcessButtons[2]
                                      .reachedTimeToAction))
                                  ? SizedBox(
                                width: 30,
                                height: 30,
                                child: SpinKitCircle(
                                    size: 30.0,
                                    color: (device
                                        .model
                                        .customerProcessButtons[
                                    2]
                                        .onInDevice)
                                        ? Styles.errorColor
                                        : Colors.white),
                              )
                                  : Image(
                                image: (processButtonColor(
                                    device
                                        .model
                                        .customerProcessButtons[
                                    2]
                                        .onInDevice,
                                    device
                                        .model
                                        .customerProcessButtons[
                                    2]
                                        .function,
                                    device
                                        .model
                                        .customerProcessButtons[
                                    2]
                                        .reachedTimeToAction))
                                    ? const AssetImage(
                                    'images/cancel_.png')
                                    : (device
                                    .model
                                    .customerProcessButtons[
                                2]
                                    .isProcessing ||
                                    !device.buttonLoading[2]
                                        .isNotProcessing)
                                    ? const AssetImage(
                                    'images/cancel.png')
                                    : Styles.button[2][getId(
                                    device
                                        .model.typeNumber)],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                        : EmptyProcessButton(
                        id: 3, type: device.userDevice.typeNumber),

                  //TODO
                  (device.isLoaded)
                      ? Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: CircularProgressIndicator(
                            strokeWidth: 10,
                            //backgroundColor: Theme.of(context).accentColor,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              (device.model.customerProcessButtons[1]
                                  .onInDevice)
                                  ? Styles.errorColor
                                  : Theme
                                  .of(context)
                                  .primaryColor,
                            ),
                            value: (device.buttonLoading[1].isCancelled)
                                ? 0
                                : ((device.buttonLoading[1].isStarted)
                                ? 0.01
                                : device.buttonLoading[1].progress),
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (device
                                  .buttonLoading[1].isNotProcessing) {
                                if (device.model.customerProcessButtons[1]
                                    .isProcessing) {
                                  device.buttonLoading[1].condition =
                                      device
                                          .model
                                          .customerProcessButtons[1]
                                          .onInDevice;
                                } else {
                                  device.buttonLoading[1].condition =
                                  !device
                                      .model
                                      .customerProcessButtons[1]
                                      .onInDevice;
                                }
                                final bool shouldStartTimer = !device
                                    .model
                                    .customerProcessButtons[1]
                                    .isProcessing;
                                if (shouldStartTimer) {
                                  try {
                                    setStateIfMounted(() {
                                      device.buttonLoading[1]
                                          .toggle(true);
                                    });
                                    await device.callProcess(
                                        2,
                                        device
                                            .buttonLoading[1].condition);
                                    // GITHUB print('in 211, ');
                                  } catch (e) {
                                    setStateIfMounted(() {
                                      device.buttonLoading[1].isStarted =
                                      false;
                                    });
                                    // GITHUB print(e);
                                  }
                                }
                              } else {
                                device.buttonLoading[1].condition =
                                !device.buttonLoading[1].condition;
                                // GITHUB print('236');
                                try {
                                  setStateIfMounted(() {
                                    device.buttonLoading[1].toggle(false);
                                  });
                                  await device.callProcess(2,
                                      device.buttonLoading[1].condition);
                                  // GITHUB print('243, isCancelled: ' +
                                      // device.buttonLoading[1].isCancelled
                                      //    .toString() +
                                      // ', isStarted: ' +
                                      // device.buttonLoading[1].isStarted
                                      //    .toString() +
                                      // ', progress: ' +
                                      // device.buttonLoading[1].progress
                                      //    .toString());
                                  //device.buttonLoading[1].refresh();
                                } catch (e) {
                                  setStateIfMounted(() {
                                    device.buttonLoading[1].isCancelled =
                                    false;
                                    device.buttonLoading[1].condition =
                                    !device
                                        .buttonLoading[1].condition;
                                  });
                                  // GITHUB print(e);
                                }
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const CircleBorder()),
                              //padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                              backgroundColor: MaterialStateProperty.all(
                                  (processButtonColor(
                                      device
                                          .model
                                          .customerProcessButtons[1]
                                          .onInDevice,
                                      device
                                          .model
                                          .customerProcessButtons[1]
                                          .function,
                                      device
                                          .model
                                          .customerProcessButtons[1]
                                          .reachedTimeToAction))
                                      ? ((Theme
                                      .of(context)
                                      .brightness ==
                                      Brightness.light)
                                      ? Styles.primaryColorLight
                                      : Styles.primaryColorDark)
                                      : ((Theme
                                      .of(context)
                                      .brightness ==
                                      Brightness.light)
                                      ? Styles.processButtonColorLight
                                      : Styles
                                      .processButtonColorDark)),
                              overlayColor: MaterialStateProperty
                                  .resolveWith<Color?>(
                                    (states) {
                                  if (states
                                      .contains(MaterialState.pressed)) {
                                    if (device
                                        .model
                                        .customerProcessButtons[1]
                                        .isProcessing) {
                                      return Styles.errorColor;
                                    }
                                    if (device
                                        .model
                                        .customerProcessButtons[1]
                                        .function) {
                                      return const Color.fromRGBO(
                                          187, 187, 187, 1);
                                    }
                                    return Theme
                                        .of(context)
                                        .primaryColor;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            child: (isWaiting(
                                device.model.customerProcessButtons[1]
                                    .onInDevice,
                                device.model.customerProcessButtons[1]
                                    .function,
                                device.model.customerProcessButtons[1]
                                    .reachedTimeToAction))
                                ? SizedBox(
                              width: 30,
                              height: 30,
                              child: SpinKitCircle(
                                  size: 30.0,
                                  color: (device
                                      .model
                                      .customerProcessButtons[1]
                                      .onInDevice)
                                      ? Styles.errorColor
                                      : Colors.white),
                            )
                                : Image(
                              image: (processButtonColor(
                                  device
                                      .model
                                      .customerProcessButtons[1]
                                      .onInDevice,
                                  device
                                      .model
                                      .customerProcessButtons[1]
                                      .function,
                                  device
                                      .model
                                      .customerProcessButtons[1]
                                      .reachedTimeToAction))
                                  ? const AssetImage(
                                  'images/cancel_.png')
                                  : (device
                                  .model
                                  .customerProcessButtons[
                              1]
                                  .isProcessing ||
                                  !device.buttonLoading[1]
                                      .isNotProcessing)
                                  ? const AssetImage(
                                  'images/cancel.png')
                                  : Styles.button[1][getId(
                                  device.userDevice
                                      .typeNumber)],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      : EmptyProcessButton(
                      id: 2, type: device.userDevice.typeNumber),
                  //TODO
                  (device.isLoaded)
                      ? Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: CircularProgressIndicator(
                            strokeWidth: 10,
                            //backgroundColor: Theme.of(context).accentColor,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              (device.model.customerProcessButtons[0]
                                  .onInDevice)
                                  ? Styles.errorColor
                                  : Theme
                                  .of(context)
                                  .primaryColor,
                            ),
                            value: (device.buttonLoading[0].isCancelled)
                                ? 0
                                : ((device.buttonLoading[0].isStarted)
                                ? 0.01
                                : device.buttonLoading[0].progress),
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (device
                                  .buttonLoading[0].isNotProcessing) {
                                if (device.model.customerProcessButtons[0]
                                    .isProcessing) {
                                  device.buttonLoading[0].condition =
                                      device
                                          .model
                                          .customerProcessButtons[0]
                                          .onInDevice;
                                } else {
                                  device.buttonLoading[0].condition =
                                  !device
                                      .model
                                      .customerProcessButtons[0]
                                      .onInDevice;
                                }
                                final bool shouldStartTimer = !device
                                    .model
                                    .customerProcessButtons[0]
                                    .isProcessing;
                                if (shouldStartTimer) {
                                  try {
                                    setStateIfMounted(() {
                                      device.buttonLoading[0]
                                          .toggle(true);
                                    });
                                    await device.callProcess(
                                        1,
                                        device
                                            .buttonLoading[0].condition);
                                    // GITHUB print('340, isCancelled: ' +
                                        //device
                                        //    .buttonLoading[0].isCancelled
                                        //    .toString() +
                                        //', isStarted: ' +
                                        //device.buttonLoading[0].isStarted
                                        //    .toString() +
                                        //', progress: ' +
                                        //device.buttonLoading[0].progress
                                        //    .toString());
                                    //device.buttonLoading[0].startTimer();
                                  } catch (e) {
                                    setStateIfMounted(() {
                                      device.buttonLoading[0].isStarted =
                                      false;
                                    });
                                    // GITHUB print(e);
                                  }
                                }
                              } else {
                                device.buttonLoading[0].condition =
                                !device.buttonLoading[0].condition;
                                // GITHUB print('353');
                                try {
                                  setStateIfMounted(() {
                                    device.buttonLoading[0].toggle(false);
                                    // GITHUB print(device
                                        // .buttonLoading[0].isCancelled);
                                    // GITHUB print(device
                                       // .buttonLoading[0].isStarted);
                                  });
                                  await device.callProcess(1,
                                      device.buttonLoading[0].condition);
                                  // GITHUB print('355, isCancelled: ' +
                                      // device.buttonLoading[0].isCancelled
                                      //    .toString() +
                                      //', isStarted: ' +
                                      //device.buttonLoading[0].isStarted
                                      //    .toString() +
                                      //', progress: ' +
                                      //device.buttonLoading[0].progress
                                      //    .toString());
                                  //device.buttonLoading[0].refresh();
                                } catch (e) {
                                  setStateIfMounted(() {
                                    device.buttonLoading[0].isCancelled =
                                    false;
                                    device.buttonLoading[0].condition =
                                    !device
                                        .buttonLoading[0].condition;
                                  });
                                  //print(e);
                                }
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const CircleBorder()),
                              //padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                              backgroundColor: MaterialStateProperty.all(
                                  (processButtonColor(
                                      device
                                          .model
                                          .customerProcessButtons[0]
                                          .onInDevice,
                                      device
                                          .model
                                          .customerProcessButtons[0]
                                          .function,
                                      device
                                          .model
                                          .customerProcessButtons[0]
                                          .reachedTimeToAction))
                                      ? ((Theme
                                      .of(context)
                                      .brightness ==
                                      Brightness.light)
                                      ? Styles.primaryColorLight
                                      : Styles.primaryColorDark)
                                      : ((Theme
                                      .of(context)
                                      .brightness ==
                                      Brightness.light)
                                      ? Styles.processButtonColorLight
                                      : Styles
                                      .processButtonColorDark)),
                              overlayColor: MaterialStateProperty
                                  .resolveWith<Color?>(
                                    (states) {
                                  if (states
                                      .contains(MaterialState.pressed)) {
                                    if (device
                                        .model
                                        .customerProcessButtons[0]
                                        .isProcessing) {
                                      return Styles.errorColor;
                                    }
                                    if (device
                                        .model
                                        .customerProcessButtons[0]
                                        .function) {
                                      return const Color.fromRGBO(
                                          187, 187, 187, 1);
                                    }
                                    return Theme
                                        .of(context)
                                        .primaryColor;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            child: (isWaiting(
                                device.model.customerProcessButtons[0]
                                    .onInDevice,
                                device.model.customerProcessButtons[0]
                                    .function,
                                device.model.customerProcessButtons[0]
                                    .reachedTimeToAction))
                                ? SizedBox(
                              width: 30,
                              height: 30,
                              child: SpinKitCircle(
                                  size: 30.0,
                                  color: (device
                                      .model
                                      .customerProcessButtons[0]
                                      .onInDevice)
                                      ? Styles.errorColor
                                      : Colors.white),
                            )
                                : Image(
                              image: (processButtonColor(
                                  device
                                      .model
                                      .customerProcessButtons[0]
                                      .onInDevice,
                                  device
                                      .model
                                      .customerProcessButtons[0]
                                      .function,
                                  device
                                      .model
                                      .customerProcessButtons[0]
                                      .reachedTimeToAction))
                                  ? const AssetImage(
                                  'images/cancel_.png')
                                  : (device
                                  .model
                                  .customerProcessButtons[
                              0]
                                  .isProcessing ||
                                  !device.buttonLoading[0]
                                      .isNotProcessing)
                                  ? const AssetImage(
                                  'images/cancel.png')
                                  : Styles.button[0][getId(
                                  device.userDevice
                                      .typeNumber)],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      : EmptyProcessButton(
                      id: 1, type: device.userDevice.typeNumber),
                  //TODO
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            if (!device.isLoaded)
              Row(
                children: [
                  const SizedBox(width: 10.0),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color:
                          (Theme
                              .of(context)
                              .brightness == Brightness.light)
                              ? Styles.overlineColorLight
                              : Styles.overlineColorDark,
                          width: 1.5,
                          style: BorderStyle.solid),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),
                      //color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    'در حال دریافت اطلاعات از سرور',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'IRANYekanWeb',
                      color: (Theme
                          .of(context)
                          .brightness == Brightness.light)
                          ? Styles.overlineColorLight
                          : Styles.overlineColorDark,
                    ),
                  ),
                ],
              ),
            if (notReachable)
              Row(
                children: [
                  const SizedBox(width: 10.0),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      color: Styles.errorColor,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  const Text(
                    'ارتباط با دستگاه مقدور نیست',
                    style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'IRANYekanWeb',
                        color: Styles.errorColor),
                  ),
                ],
              ),
            if (buttonActive[0] || buttonActive[1])
              Row(
                children: [
                  const SizedBox(width: 10.0),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),
                      color: (Theme
                          .of(context)
                          .brightness == Brightness.light)
                          ? Styles.primaryColorLight
                          : Styles.primaryColorDark,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  if (buttonActive[0] && buttonActive[1])
                    Text(
                      ((device.model.networkCoverage > 0) ? '' : 'احتمالاً ') +
                          Strings
                              .bothActive[getId(device.userDevice.typeNumber)],
                      style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'IRANYekanWeb',
                          color:
                          (Theme
                              .of(context)
                              .brightness == Brightness.light)
                              ? Styles.overlineColorLight
                              : Styles.overlineColorDark),
                    ),
                  if (buttonActive[0] && !buttonActive[1])
                    Text(
                      ((device.model.networkCoverage > 0) ? '' : 'احتمالاً ') +
                          Strings.process0Active[
                          getId(device.userDevice.typeNumber)],
                      style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'IRANYekanWeb',
                          color:
                          (Theme
                              .of(context)
                              .brightness == Brightness.light)
                              ? Styles.overlineColorLight
                              : Styles.overlineColorDark),
                    ),
                  if (buttonActive[1] && !buttonActive[0])
                    Text(
                      ((device.model.networkCoverage > 0) ? '' : 'احتمالاً ') +
                          Strings.process1Active[
                          getId(device.userDevice.typeNumber)],
                      style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'IRANYekanWeb',
                          color:
                          (Theme
                              .of(context)
                              .brightness == Brightness.light)
                              ? Styles.overlineColorLight
                              : Styles.overlineColorDark),
                    ),
                  const SizedBox(height: 10.0),
                ],
              ),
            if (buttonOngoing[0])
              Row(
                children: [
                  const SizedBox(width: 10.0),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color:
                          (Theme
                              .of(context)
                              .brightness == Brightness.light)
                              ? Styles.primaryColorLight
                              : Styles.primaryColorDark,
                          width: (isWaiting(
                              device.model.customerProcessButtons[0]
                                  .onInDevice,
                              device.model.customerProcessButtons[0]
                                  .function,
                              device.model.customerProcessButtons[0]
                                  .reachedTimeToAction) ||
                              device.buttonLoading[0].isConnecting)
                              ? 2
                              : 1.5,
                          style: BorderStyle.solid),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),
                      //color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    'در ' +
                        ((isWaiting(
                            device
                                .model.customerProcessButtons[0].onInDevice,
                            device.model.customerProcessButtons[0].function,
                            device.model.customerProcessButtons[0]
                                .reachedTimeToAction))
                            ? 'حال '
                            : 'انتظار ') +
                        'ارسال دستور ' +
                        ((device.model.customerProcessButtons[0].onInDevice)
                            ? 'پایان '
                            : 'شروع ') +
                        Strings
                            .process0Name[getId(device.userDevice.typeNumber)],
                    //Text('در حال ارسال دستور به دستگاه',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'IRANYekanWeb',
                      color: (Theme
                          .of(context)
                          .brightness == Brightness.light)
                          ? Styles.overlineColorLight
                          : Styles.overlineColorDark,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            if (buttonOngoing[1])
              Row(
                children: [
                  const SizedBox(width: 10.0),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color:
                          (Theme
                              .of(context)
                              .brightness == Brightness.light)
                              ? Styles.primaryColorLight
                              : Styles.primaryColorDark,
                          width: (isWaiting(
                              device.model.customerProcessButtons[1]
                                  .onInDevice,
                              device.model.customerProcessButtons[1]
                                  .function,
                              device.model.customerProcessButtons[1]
                                  .reachedTimeToAction) ||
                              device.buttonLoading[1].isConnecting)
                              ? 2
                              : 1.5,
                          style: BorderStyle.solid),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),
                      //color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    'در ' +
                        ((isWaiting(
                            device
                                .model.customerProcessButtons[1].onInDevice,
                            device.model.customerProcessButtons[1].function,
                            device.model.customerProcessButtons[1]
                                .reachedTimeToAction))
                            ? 'حال '
                            : 'انتظار ') +
                        'ارسال دستور ' +
                        ((device.model.customerProcessButtons[1].onInDevice)
                            ? 'پایان '
                            : 'شروع ') +
                        Strings
                            .process1Name[getId(device.userDevice.typeNumber)],
                    //Text('در حال ارسال دستور به دستگاه',
                    style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'IRANYekanWeb',
                        color:
                        (Theme
                            .of(context)
                            .brightness == Brightness.light)
                            ? Styles.overlineColorLight
                            : Styles.overlineColorDark),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
