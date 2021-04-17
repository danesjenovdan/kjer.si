<template src='./Chat.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./Chat.scss" lang="scss">
</style>

<script>

  import Discover from "../Discover/Discover";
  import Events from "../Events/Events";
  import * as AppService from '../../services/app.service';
  import * as UserService from '../../services/user.service';
  import * as app from '@nativescript/core/application';
  import * as platform from '@nativescript/core/platform';
  import * as Phx from "../../assets/js/phoenix";
  import * as ApiService from "../../services/api.service";
  import {ObservableArray} from '@nativescript/core/data/observable-array';
  import * as utils from "@nativescript/core/utils/utils";
  import {isIOS, isAndroid} from "@nativescript/core/platform";
  import * as frame from "@nativescript/core/ui/frame";

  export default {
    props: ['roomId', 'roomName'],
    data() {
      return {
        showMenu: false,
        channel: null,
        userId: UserService.default.user.id,
        messageText: '',
        messages: new ObservableArray([]),
      };
    },
    computed: {
      message() {
        return "Blank {N}-Vue app";
      }
    },
    mounted() {

      this.$refs.pageRef.nativeView.actionBarHidden = true;
      if (platform.isAndroid) {
        const window = app.android.startActivity.getWindow();
        window.setSoftInputMode(android.view.WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
      }

      this.setupChannel();

      this.messages.on(ObservableArray.changeEvent, this.onMessagesUpdate.bind(this));

    },
    destroyed() {
      console.log('Destroyed');
      // to leave a channel
      if (this.channel) {
        this.channel.leave();
      }
    },
    methods: {
      setupChannel() {

        console.log('this.roomId: ', this.roomId);

        // to create a channel
        this.channel = ApiService.default.socket.channel(`room:${this.roomId}`, {});

        // listen for 'shout' events
        this.channel.on('shout', payload => {
          const message = payload;
          console.log('SHOUT');
          console.log(payload);

          if (message.userId === this.userId) {
            message.type = 'my_text';
          } else {
            message.type = 'text';
          }
          this.messages.push(message);
        });


        console.log('Join channel: ', ApiService.default.socket.isConnected());

        ApiService.default.initSocket();

        console.log('Join channel: ', ApiService.default.socket.isConnected());

        // join the channel, with success and failure callbacks
        this.channel.join()
          .receive('ok', resp => console.log('Joined channel successfully', resp))
          .receive('error', resp => console.log('Failed to join channel', resp))
          .receive("timeout", () => console.log("Networking issue..."));

      },

      onMessagesUpdate() {

        setTimeout(() => {
          if (platform.isAndroid) {
            if (this.$refs.chatListView.nativeView.android) {
              this.$refs.chatListView.nativeView.android.smoothScrollToPosition(this.messages.length - 1);
              // this.$refs.chatListView.nativeView.scrollToIndex(this.chat.messages.length - 1);
            } else {
              this.$refs.chatListView.nativeView.scrollToIndex(this.messages.length - 1);
            }
          }
        });

      },

      onSendTap() {

        if (!this.messageText) {
          return;
        }

        console.log('Send message');

        // to send messages
        this.channel.push('shout', {
          content: this.messageText,
        }).receive("ok", (msg) => console.log("created message", msg))
          .receive("error", (reasons) => console.log("create failed", reasons))
          .receive("timeout", () => console.log("Networking issue..."));

        this.messageText = '';
        // this.dismissSoftKeyboard();

      },

      dismissSoftKeyboard() {

        if (isIOS) {
          frame.topmost().nativeView.endEditing(true);
        }
        if (isAndroid) {
          utils.ad.dismissSoftInput();
        }

      },

      goToDiscoverPage() {
        console.log('TAP: go to discover page');
        this.$navigateTo(Discover);
      },

      onBackTap() {
        console.log('TAP: go back');
        this.$navigateBack();
      },

      onContainerTap() {
        this.showMenu = false;
      },

      onMenuTap() {
        console.log('TAP: open menu');
        setTimeout(() => {
          this.showMenu = true;
        }, 10);
      },

      onEventsTap() {
        console.log('TAP: events');
        this.$navigateTo(Events, {
          transition: {
            name: 'slideLeft',
            duration: 300,
            curve: 'easeInOut'
          }
        });
      }

    }
  };

</script>
