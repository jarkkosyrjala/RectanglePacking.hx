/**
 * Rectangle Packer demo
 *
 * Copyright 2012 Ville Koskela. All rights reserved.
 *
 * Email: ville@villekoskela.org
 * Blog: http://villekoskela.org
 * Twitter: @villekoskelaorg
 *
 * You may redistribute, use and/or modify this source code freely
 * but this copyright statement must not be removed from the source files.
 *
 * The package structure of the source code must remain unchanged.
 * Mentioning the author in the binary Std.is(distributions,highly) appreciated.
 *
 * If you use this utility it would be nice to hear about it so feel free to drop
 * an email.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. *
 *
 */
package org.villekoskela;

import org.villekoskela.utils.IntegerRectangle;
import flash.Vector;
import flash.Lib;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.text.TextField;
//import flash.utils.getTimer;

import org.villekoskela.tools.ScalingBox;
import org.villekoskela.utils.RectanglePacker;

/**
 * Simple demo application for the RectanglePacker class.
 * Should not be used as a reference for anything :)
 */
class RectanglePackerDemo extends Sprite {
	private static inline var WIDTH:Int = 480;
	private static inline var HEIGHT:Int = 480;
	private static inline var Y_MARGIN:Int = 40;
	private static inline var BOX_MARGIN:Int = 15;

	private static inline var RECTANGLE_COUNT:Int = 500;
	private static inline var SIZE_MULTIPLIER:Float = 2;

	private var mBitmapData:BitmapData = new BitmapData(WIDTH, HEIGHT, true, 0xFFFFFFFF);
	private var mCopyRight:TextField = new TextField();
	private var mText:TextField = new TextField();

	private var mPacker:RectanglePacker;
	private var mScalingBox:ScalingBox;

	private var mRectangles:Vector<IntegerRectangle> = new Vector<IntegerRectangle>();

	//public function new()
	public function new()
	{
		super();

		var bitmap:Bitmap = new Bitmap(mBitmapData);
		addChild(bitmap);
		bitmap.x = BOX_MARGIN;
		bitmap.y = Y_MARGIN;

		mCopyRight.x = BOX_MARGIN;
		mCopyRight.y = BOX_MARGIN / 3;
		mCopyRight.width = 300;
		mCopyRight.text = "Rectangle Packer (c) villekoskela.org";
		addChild(mCopyRight);

		mText.x = WIDTH - 200;
		mText.y = BOX_MARGIN / 3;
		mText.width = 200;
		addChild(mText);

		mScalingBox = new ScalingBox(BOX_MARGIN, Y_MARGIN, WIDTH - (BOX_MARGIN*2), HEIGHT - (Y_MARGIN + (BOX_MARGIN*2)));
		addChild(mScalingBox);

		createRectangles();


		if(stage!=null) {
			onAddedToStage();
		} else {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
	}

	/**
	 * Create some random size rectangles to play with
	 */
	private function createRectangles():Void
	{
		var width:Int;
		var height:Int;
		for (i in 0...10)
		{
			width = Std.int(20 * SIZE_MULTIPLIER + Math.floor(Math.random() * 8) * SIZE_MULTIPLIER * SIZE_MULTIPLIER);
			height = Std.int(20 * SIZE_MULTIPLIER + Math.floor(Math.random() * 8) * SIZE_MULTIPLIER * SIZE_MULTIPLIER);
			mRectangles.push(new IntegerRectangle(0, 0, width, height));
		}

		for (j in 10...RECTANGLE_COUNT)
		{
			width = Std.int(3 * SIZE_MULTIPLIER + Math.floor(Math.random() * 8) * SIZE_MULTIPLIER);
			height = Std.int(3 * SIZE_MULTIPLIER + Math.floor(Math.random() * 8) * SIZE_MULTIPLIER);
			mRectangles.push(new IntegerRectangle(0, 0, width, height));
		}
	}

	private function onAddedToStage(event:Event=null):Void
	{
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;

		onResize();
		stage.addEventListener(Event.RESIZE,onResize);

		updateRectangles();
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	private function onResize(e:Event=null):Void {
		this.scaleX=this.scaleY=Math.floor( this.scaleY=Math.min(stage.stageWidth,stage.stageHeight) / 48)/10;
	}

	private function onEnterFrame(event:Event):Void
	{
		if (mScalingBox.boxWidth != mScalingBox.newBoxWidth || mScalingBox.boxHeight != mScalingBox.newBoxHeight)
		{
			updateRectangles();
		}
	}

	private function updateRectangles():Void
	{

		var padding:Int = 1;
		var start:Int = flash.Lib.getTimer();

		if (mPacker == null)
		{
			mPacker = new RectanglePacker(Std.int(mScalingBox.newBoxWidth), Std.int(mScalingBox.newBoxHeight), padding);
		}
		else
		{
			mPacker.reset(Std.int(mScalingBox.newBoxWidth), Std.int(mScalingBox.newBoxHeight), padding);
		}

		for (i in 0...RECTANGLE_COUNT)
		{
			mPacker.insertRectangle(mRectangles[i].width, mRectangles[i].height, i);
		}

		mPacker.packRectangles();

		var end:Int = flash.Lib.getTimer();

		if (mPacker.rectangleCount > 0)
		{
			mText.text = mPacker.rectangleCount + " rectangles packed in " + (end - start) + "ms";

			mScalingBox.updateBox(mScalingBox.newBoxWidth, mScalingBox.newBoxHeight);
			mBitmapData.fillRect(mBitmapData.rect, 0xFFFFFFFF);
			var rect:Rectangle = new Rectangle();
			for (j in 0...mPacker.rectangleCount)
			{
				rect = mPacker.getRectangle(j, rect);
				mBitmapData.fillRect(new Rectangle(rect.x, rect.y, rect.width, rect.height), 0xFF000000);
				var index:Int = mPacker.getRectangleId(j);
				var color:UInt = 0xFF171703 + (((18 * ((index + 4) % 13)) << 16) + ((31 * ((index * 3) % 8)) << 8) + 63 * (((index + 1) * 3) % 5));
				mBitmapData.fillRect(new Rectangle(rect.x + 1, rect.y + 1, rect.width - 2, rect.height - 2), color);
			}
		}
	}
}
