/**
 * Created by 28713 on 2016/12/20.
 */
function Scroll(obj){
    this.num = null;//滚动的页数
    this.width = 1210;//每一页的宽度
    this.height = 450;//每一页的高度
    this.n = 1;//当前页
    this.timer1 = null;//滚动一页的计时器
    this.timer2 = null;//自动滚动的计时器
    this.container = null;//滚动结构
    this.out = null;//滚动容器
    this.inner = null;//包裹容器
    this.left = null;//向左滚动按钮
    this.right = null;//向右滚动按钮
    this.imgs_indexs = null;//图片序号
}
Scroll.prototype.init = function(obj){
    //初始化容器
    this.container = document.querySelector(obj);
    this.out = this.container.querySelector(".lyc-out");
    this.inner = this.container.querySelector(".lyc-inner");
    this.num = this.inner.querySelectorAll("li").length-1;
    this.inner.style.height = this.height+"px";
    this.inner.style.width=this.width*(this.num+1)+"px";
    this.imgs_indexs = this.container.querySelector(".lyc-imgs_indexs");
    this.left = this.container.querySelector(".lyc-left");
    this.right = this.container.querySelector(".lyc-right");
    this.out.scrollLeft = this.width;
    //自动滚动开始
    this.automove();
};
Scroll.prototype.move = function(n){
    var self = this;
    var step = 0;
    var maxstep = 20;
    var pos = self.out.scrollLeft;
    var end = this.width*n;
    var every = (end-pos)/maxstep;

    clearInterval(self.timer1);
    self.timer1 = setInterval(function(){
        step++;
        if(step>=maxstep){
            clearInterval(self.timer1);
            self.out.scrollLeft=end;
            step=0;
        }
        pos+=every;
        self.out.scrollLeft=pos;
    },10);
};
Scroll.prototype.automove = function(){
    var self = this;
    clearInterval(self.timer2);
    self.timer2=setInterval(function(){
        self.n++;
        if(self.n>self.num){
            self.n=1;
            self.out.scrollLeft=0;
        }
        self.move(self.n);
        self.current();
    },2000);
    self.arrow();
    self.tap();
};
Scroll.prototype.arrow = function(){
    var self = this;
    if(!self.left){
        return;
    }
    self.left.onclick=function(){
        clearInterval(self.timer1);
        clearInterval(self.timer2);
        self.n--;
        if(self.n<0){
            self.n=self.num-1;
            self.out.scrollLeft = self.width*self.num;
        }
        self.move(self.n);
        self.current();
        self.automove();
    };
    self.right.onclick=function(){
        clearInterval(self.timer1);
        clearInterval(self.timer2);
        self.n++;
        if(self.n>self.num){
            self.n=1;
            self.out.scrollLeft = 0;
        }
        self.move(self.n);
        self.current();
        self.automove();
    }
};
Scroll.prototype.tap = function(){
    var self = this;
    if(!self.imgs_indexs){
        return;
    }
    var imgs_index = self.imgs_indexs.getElementsByTagName("li");
    for(var i=0;i<self.num;i++){
        imgs_index[i].onclick=function(){
            for(var i=0;i<self.num;i++){
                imgs_index[i].className="";
                if(this==imgs_index[i]){
                    self.n=i+1;
                    self.move(self.n);
                    self.current();
                    self.automove();
                }
            }
        }
    }

};
Scroll.prototype.current = function(){
    var self = this;
    if(!self.imgs_indexs){
        return;
    }
    var imgs_index = self.imgs_indexs.getElementsByTagName("li");
    for(var i=0;i<self.num;i++){
        imgs_index[i].className="";
    }
    if(self.n==0){
        imgs_index[self.num-1].className='lyc-current';
    }else{
        imgs_index[self.n-1].className='lyc-current';
    }
};
var scroll = new Scroll();
scroll.init(".lyc-container");