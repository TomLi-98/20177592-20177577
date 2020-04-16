<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>师门树</title>
    <style>#text{width: 30%;height:300px;resize: none;}</style>
</head>
<body>
<textarea id="text" placeholder="请严格按照以下格式进行输入:&#10;
        导师：张三&#10;
        2016级博士生：天一、王二、吴五&#10;
        2015级硕士生：李四、王五、许六&#10;
        2016级硕士生：刘一、李二、李三&#10;
        2017级本科生：刘六、琪七、司四&#10;
        注意：导师和他/她所带全体的学生称为一组数据，可以同时输入多组数据。&#10;"></textarea>
<input type="button" id="export" onclick="getree()" value="确定">
</body>
<div id="mountNode"></div>
<script src="https://gw.alipayobjects.com/os/antv/pkg/_antv.g6-3.1.1/build/g6.js"></script>
<script src="https://gw.alipayobjects.com/os/antv/assets/lib/jquery-3.2.1.min.js"></script>
<script src="https://gw.alipayobjects.com/os/antv/pkg/_antv.hierarchy-0.5.0/build/hierarchy.js"></script>
<script>

    function getree()
    {
        var total = new Array();
        var text = document.getElementById("text").value;
        var textarray = text.split('\n');
        for (i = 0; i < textarray.length; i++) {
            if (i == 0) {
                var teacher = new Array();
                total.push(textarray[0].substr(3));
            } else {
                var istudents = new Array();
                var temp = [];
                var j;
                istudents.push(textarray[i].substr(0, 8));
                temp = textarray[i].substr(9).split('、');
                for (j = 0; j < temp.length; j++)
                    istudents.push(temp[j]);
                total.push(istudents);
                //console.log(istudents);
            }
            //console.log(total);
        }
        var m, k;
        var data = {};
        for (m = 0; m < total.length; m++) {
            if (m == 0) {
                data.id = total[0];//根节点导师名字
                data.children = [];//每一届学生年份信息
            } else {
                var temp1 = {};//每一届学生信息
                for (k = 0; k < total[m].length; k++) {
                    var eachyearstudent = {};//每一位学生名字作为Id
                    if (k == 0) {
                        temp1.id = total[m][0];//学生年份
                        temp1.children = [];//学生名单
                    } else {
                        eachyearstudent.id = total[m][k];
                        temp1.children.push(eachyearstudent);
                    }
                }
                // console.log(temp1);
                data.children.push(temp1);
            }
        }
        var graph = new G6.TreeGraph({
            container: 'mountNode',
            width: window.innerWidth,
            height: window.innerHeight,
            pixelRatio: 2,
            modes: {
                default: [{
                    type: 'collapse-expand',
                    onChange: function onChange(item, collapsed) {
                        var data = item.get('model').data;
                        data.collapsed = collapsed;
                        return true;}
                    }, 'drag-canvas', 'zoom-canvas']},
            defaultNode: {
                size: 16,
                anchorPoints: [[0, 0.5], [1, 0.5]],
                style: {fill: '#40a9ff', stroke: '#096dd9'}
            },
            defaultEdge: {
                shape: 'cubic-horizontal',
                style: {stroke: '#A3B1BF'}
            },
            layout: {
                type: 'compactBox',
                direction: 'LR',
                getId: function getId(d) {return d.id;},
                getHeight: function getHeight() {return 16;},
                getWidth: function getWidth() {return 16;},
                getVGap: function getVGap() {return 10;},
                getHGap: function getHGap() {return 100;}
            }
    });
    graph.node(function(node){
        return {
            size: 26,
            style: {fill: '#40a9ff', stroke: '#096dd9'},
            label: node.id,
            labelCfg: {
                 position: node.children && node.children.length > 0 ? 'left' : 'right'}
            };
    });
    graph.data(data);
    graph.render();
    graph.fitView();
    }
    getTree()
</script>
</body>
</html>