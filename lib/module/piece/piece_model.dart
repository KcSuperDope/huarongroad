import 'package:flutter/material.dart';

enum Direction { left, right, up, down }

enum PieceState { normal, empty }

class PieceModel {
  int? id;
  int? dx;
  int? dy;
  int? kind;

  // int? location;
  double? width;
  double? height;
  Color? color;
  int? limitCount;
  bool? isNumber;
  int? number;
  bool? available;
  int? tox;
  int? toy;
  bool? isLock;
  String? image;
  Color? numberColor;
  Direction? arrowDirection;
  double? arrowAngle;
  double? arrowPositionTop;
  double? arrowPositionLeft;
  PieceState? state;

  PieceModel({
    this.id,
    this.dx,
    this.dy,
    // this.location,
    this.kind,
    this.width,
    this.height,
    this.color,
    this.limitCount = 0,
    this.isNumber = false,
    this.number = 1,
    this.arrowDirection = Direction.down,
    this.available = true,
    this.tox,
    this.toy,
    this.image,
    this.isLock,
    this.numberColor,
    this.arrowAngle,
    this.arrowPositionLeft,
    this.arrowPositionTop,
    this.state = PieceState.normal,
  });

  PieceModel clone() {
    return PieceModel(
      id: id,
      dx: dx,
      dy: dy,
      kind: kind,
      width: width,
      height: height,
      color: color,
      // location: location,
      limitCount: limitCount,
      isNumber: isNumber,
      number: number,
      available: available,
      image: image,
      isLock: isLock,
      numberColor: numberColor,
      arrowDirection: arrowDirection,
      arrowAngle: arrowAngle,
      arrowPositionTop: arrowPositionTop,
      arrowPositionLeft: arrowPositionLeft,
    );
  }

  /// 是否越界
  bool overlaps(PieceModel other) {
    if ((dx! + width!) <= other.dx! || (other.dx! + other.width!) <= dx!) return false;
    if ((dy! + height!) <= other.dy! || (other.dy! + other.height!) <= dy!) return false;
    return true;
  }

  /// 当前块占位
  List<int> place([int colNum = 4]) {
    List<int> res = [];
    for (int i = dy!; i < dy! + height!; i++) {
      for (int j = dx!; j < dx! + width!; j++) {
        res.add(i * colNum + j);
      }
    }
    return res;
  }

  List<Offset> placeInBoard() {
    List<Offset> res = [];
    for (int i = dy!; i < dy! + height!; i++) {
      for (int j = dx!; j < dx! + width!; j++) {
        res.add(Offset(i.toDouble(), j.toDouble()));
      }
    }
    return res;
  }

  @override
  bool operator ==(Object other) {
    return (other is PieceModel && other.kind == kind && other.dx == dx && other.dy == dy && other.number == number);
  }

  @override
  int get hashCode => Object.hash(dx, dy, kind, number);
}
