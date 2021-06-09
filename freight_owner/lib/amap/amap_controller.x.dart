import 'dart:math';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:flutter/material.dart';


extension AmapControllerX on AmapController {
  /// 根据起点[from]和终点[to]坐标, 搜索出路径并将驾车路线规划结果[driveRouteResult]添加到地图上, 可以配置交通拥堵情况[trafficOption],
  /// 路线的宽度[lineWidth], 自定纹理[customTexture].
  Future<void> addDriveRoute({
    @required LatLng from,
    @required LatLng to,
    TrafficOption trafficOption,
    double lineWidth = 10,
    Uri customTexture,
    ImageConfiguration imageConfig,
  }) async {

    assert(from != null && to != null);
    // 搜索路径
    final route = await AmapSearch.instance.searchDriveRoute(from: from, to: to);

    // 添加路径
    final pathList = await route.drivePathList;

    for (final path in pathList) {
      for (final step in await path.driveStepList) {
        if (trafficOption != null && trafficOption.show) {
          for (final tmc in await step.tmsList) {
            final status = await tmc.status;
            Color statusColor = Colors.green;
            switch (status) {
              case '缓行':
                statusColor = Colors.yellow;
                break;
              case '拥堵':
                statusColor = Colors.red;
                break;
              case '未知':
                statusColor = Colors.blue;
                break;
              default:
                break;
            }
            await addPolyline(PolylineOption(
              latLngList: await tmc.polyline,
              strokeColor: statusColor,
              width: lineWidth,
            ));
          }
        } else {
          await addPolyline(PolylineOption(
            latLngList: await step.polyline,
            width: lineWidth,
          ));
        }
      }
    }
  }

  /// 添加地区轮廓
  ///
  /// 地区名称[districtName], 轮廓宽度[width], 轮廓颜色[strokeColor], 填充颜色[fillColor]
  ///
  /// 由于一个省份可能包含多个区域, 比如浙江包含很多岛屿, 如果把岛屿也画进去, 那么会非常消耗性能.
  /// 业务上而言, 我认为这些岛屿是否画进去基本上不影响使用, 所以增加了[onlyMainDistrict]参数
  /// 来控制是否只显示主要部分的边界, 如果你对地区完整度的需求非常高, 那么就把[onlyMainDistrict]
  /// 设置为false, 随之而来像浙江这种地区的边界绘制起来就会非常慢.
  /// 我的测试结果是MIX 3, release模式下需要5-6秒才能绘制完成.
  ///
  /// 采样率[sampleRate]可以控制经纬度列表的密度, 如果地区边界的经纬度列表长度非常长, 造成了卡顿,
  /// 那么可以把采样率调低一点, 这样画出来的区域可能没有采样率为1时那么精确, 但是减小了经纬度列表长度,
  /// 可以提升绘制速度.
  Future<List<Polygon>> addDistrictOutline(
    String districtName, {
    double width = 5,
    Color strokeColor = Colors.green,
    Color fillColor = Colors.transparent,
    bool onlyMainDistrict = true,
    double sampleRate = 1.0,
  }) async {
    assert(districtName != null && districtName.isNotEmpty);
    assert(sampleRate > 0 && sampleRate <= 1);
    final district =
        await AmapSearch.instance.searchDistrict(districtName, showBoundary: true);

    final districtList = await district.districtList;
    if (districtList.isNotEmpty) {
      if (onlyMainDistrict) {
        final sampler = Random();
        List<LatLng> boundary = await district.districtList
            .then((it) => it[0].boundary)
            // 挑出经纬度列表最长的一个边界
            .then((it) =>
                it.reduce((pre, next) => pre.length > next.length ? pre : next))
            // 根据采样率过滤经纬度列表
            .then((it) =>
                it..retainWhere((_) => sampler.nextDouble() <= sampleRate));
        return [
          await addPolygon(PolygonOption(
            latLngList: boundary,
            width: width,
            strokeColor: strokeColor,
            fillColor: fillColor,
          ))
        ];
      } else {
        List<List<LatLng>> boundaryList =
            await (await district.districtList)[0].boundary;
        return [
          for (final boundary in boundaryList)
            await addPolygon(PolygonOption(
              latLngList: boundary,
              width: width,
              strokeColor: strokeColor,
              fillColor: fillColor,
            ))
        ];
      }
    } else {
      return null;
    }
  }

  /// 添加地区轮廓
  ///
  /// 地区轮廓经纬度列表[boundary], 轮廓宽度[width], 轮廓颜色[strokeColor], 填充颜色[fillColor]
  Future<Polygon> addDistrictOutlineWithData(
    List<LatLng> boundary, {
    double width = 5,
    Color strokeColor = Colors.green,
    Color fillColor = Colors.transparent,
  }) async {
    assert(boundary != null && boundary.isNotEmpty);
    return addPolygon(PolygonOption(
      latLngList: boundary,
      width: width,
      strokeColor: strokeColor,
      fillColor: fillColor,
    ));
  }


}


