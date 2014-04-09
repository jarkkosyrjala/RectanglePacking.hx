/**
 * Scaling Box
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
package org.villekoskela.tools;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

/**
 * Utility class to provide scalable box functionality.
 */
class ScalingBox extends Sprite
{
	private var mX:Float = 0.0;
	private var mY:Float = 0.0;
	private var mWidth:Float = 0.0;
	private var mHeight:Float = 0.0;
	private var mMaxWidth:Float = 0.0;
	private var mMaxHeight:Float = 0.0;

	private var mNewWidth:Float = 0.0;
	private var mNewHeight:Float = 0.0;

	private var mDragBox:Sprite = new Sprite();
	private var mDragging:Bool = false;

	public var boxWidth(get, never):Float;
 	private function get_boxWidth():Float { return mWidth; }
	public var boxHeight(get, never):Float;
 	private function get_boxHeight():Float { return mHeight; }
	public var newBoxWidth(get, never):Float;
 	private function get_newBoxWidth():Float { return mNewWidth; }
	public var newBoxHeight(get, never):Float;
 	private function get_newBoxHeight():Float { return mNewHeight; }

	public function new(x:Float, y:Float, width:Float, height:Float)
	{
		super();
		mX = x;
		mY = y;

		mMaxWidth = width;
		mMaxHeight = height;

		this.x = x;
		this.y = y;

		mDragBox.graphics.beginFill(0xFF8050);
		mDragBox.graphics.drawCircle(0, 0, 10);
		mDragBox.graphics.endFill();

		addChild(mDragBox);

		mDragBox.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		updateBox(width, height);
	}

	public function updateBox(width:Float, height:Float):Void
	{
		mWidth = width;
		mHeight = height;
		mNewWidth = width;
		mNewHeight = height;

		graphics.clear();
		graphics.lineStyle(1.0, 0x000000);
		graphics.drawRect(0, 0, mWidth, mHeight);

		mDragBox.x = mWidth;
		mDragBox.y = mHeight;
	}

	private function onAddedToStage(event:Event):Void
	{
		this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	private function onMouseUp(event:MouseEvent):Void
	{
		mDragging = false;
	}

	private function onMouseMove(event:MouseEvent):Void
	{

		if (mDragging)
		{
			mNewWidth = event.stageX - mX;
			mNewHeight = event.stageY - mY;

			if (mNewWidth > mMaxWidth)
			{
				mNewWidth = mMaxWidth;
			}

			if (mNewHeight > mMaxHeight)
			{
				mNewHeight = mMaxHeight;
			}
		}
	}

	private function onStartDrag(event:MouseEvent):Void
	{
		mDragging = true;
	}
}